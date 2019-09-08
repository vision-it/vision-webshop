require 'spec_helper_acceptance'

describe 'vision_webshop' do
  context 'with defaults' do
    it 'run idempotently' do
      pp = <<-FILE

        file { ['/vision', '/vision/data/', '/vision/data/swarm']:
          ensure => directory,
        }
        group { 'docker':
          ensure => present,
        }

        # Just so that Puppet won't throw an error
       if($facts[os][distro][codename] != 'jessie') {
        file {['/etc/init.d/webshop_tag']:
          ensure  => present,
          mode    => '0777',
          content => 'case "$1" in *) exit 0 ;; esac'
        }}

        # mock classes
        class vision_webshop::database () {}
        class vision_docker::swarm () {}
        class vision_mysql::mariadb () {}
        class vision_gluster::node () {}
        group { 'jenkins':
          ensure => present,
        }

        class { 'vision_webshop': }
      FILE

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_failures: true)
    end
  end
  context 'Jenkins group and service' do
    describe group('jenkins') do
      it { is_expected.to exist }
    end
    describe file('/etc/systemd/system/webshop_tag.service') do
      it { is_expected.to be_file }
    end
  end

  context 'files deployed' do
    describe file('/vision/data/webshop/logs') do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by 'www-data' }
    end
    describe file('/vision/data/webshop/resources') do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by 'www-data' }
    end
    describe file('/usr/local/sbin/sync-webshop.sh') do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_mode 750 }
      its(:content) { is_expected.to match 'webshop' }
      its(:content) { is_expected.to match 'rsync' }
    end

    describe file('/vision/data/swarm/webshop.yaml') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'managed by Puppet' }
      it { is_expected.to contain 'image: registry.gitlab.cc-asp.fraunhofer.de:4567/vision-it/application/webshop:latest' }
      it { is_expected.to contain '/vision/data/webshop/resources:/var/www/html/resources' }
      it { is_expected.to contain 'DB_SOCKET=/var/run/mysqld/mysqld.sock' }
      it { is_expected.to contain 'DB_DATABASE=webshop' }
      it { is_expected.to contain 'DB_USERNAME=foo_user' }
      it { is_expected.to contain 'DB_PASSWORD=foo_password' }
      it { is_expected.to contain 'FOO=BAR' }
      it { is_expected.to contain 'traefik.port=8080' }
      it { is_expected.to contain 'traefik.frontend.rule=Host:example.com;PathPrefix:/webshop' }
    end
  end
end

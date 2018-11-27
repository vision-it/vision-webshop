require 'spec_helper_acceptance'

describe 'vision_webshop' do
  context 'with defaults' do
    it 'run idempotently' do
      pp = <<-FILE

        file { '/vision':
          ensure => directory,
        }
        group { 'docker':
          ensure => present,
        }

        class vision_webshop::docker () {}
        class vision_docker () {}

        class { 'vision_webshop': }
      FILE

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  context 'packages installed' do
    describe package('mysql-common') do
      it { is_expected.to be_installed }
    end
  end

  context 'Jenkins user and service' do
    describe user('jenkins') do
      it { is_expected.to exist }
      it { is_expected.to have_uid 50_000 }
    end

    describe file('/etc/systemd/system/webshop_tag.service') do
      it { is_expected.to be_file }
    end
  end

  context 'files deployed' do
    describe file('/data/logs') do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by 'www-data' }
    end
    describe file('/data/resources') do
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
  end
end

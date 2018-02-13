require 'spec_helper_acceptance'

describe 'vision_webshop' do
  context 'with defaults' do
    it 'run idempotently' do
      pp = <<-EOS

        file { '/vision':
          ensure => directory,
        }
        group { 'docker':
          ensure => present,
        }

        class vision_webshop::docker () {}
        class vision::docker () {}

        class { 'vision_webshop': }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  context 'packages installed' do
    describe package('mysql-common') do
      it { is_expected.to be_installed }
    end
  end
  context 'test hiera data' do
    describe file('/data/logs') do
      it { is_expected.to be_directory }
    end
    describe file('/data/resources') do
      it { is_expected.to be_directory }
    end
  end
end

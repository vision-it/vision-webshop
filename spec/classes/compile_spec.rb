# frozen_string_literal: true

require 'spec_helper'
require 'hiera'

describe 'vision_webshop' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(
          root_home: '/root',
          applicationtier: 'production'
        )
      end

      let :pre_condition do
        [
          'class vision_docker::swarm () {}',
          'class vision_mysql::mariadb () {}',
          'class vision_gluster::node () {}',
          'contain mysql::params'
        ]
      end

      # Default check to see if manifest compiles
      context 'compile' do
        it { is_expected.to compile.with_all_deps }
      end
      context 'contains' do
        it { is_expected.to contain_class('vision_webshop::docker') }
      end
    end
  end
end

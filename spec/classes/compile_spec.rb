require 'spec_helper'
require 'hiera'

describe 'vision_webshop' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(root_home: '/root')
      end
      # Default check to see if manifest compiles
      context 'compile' do
        it { is_expected.to compile.with_all_deps }
      end
      context 'contains' do
        it { is_expected.to contain_class('vision_jenkins::user') }
        it { is_expected.to contain_class('vision_docker') }
        it { is_expected.to contain_class('vision_webshop::docker') }
      end
    end
  end
end

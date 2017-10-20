require 'spec_helper'
require 'hiera'

describe 'vision_webshop::docker' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      # let(:params) do
      #   {
      #     gitlab_version: '1.2.3',
      #     postgresql_version: '1.2.3'
      #   }
      # end
      # Default check to see if manifest compiles
      context 'compile' do
        it { is_expected.to compile.with_all_deps }
      end
      context 'contains' do
        it { is_expected.to contain_class('vision_docker') }
        it { is_expected.to contain_docker__image('webshop').with_image_tag('master') }
      end
    end
  end
end

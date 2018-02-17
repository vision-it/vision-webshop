require 'spec_helper'
require 'hiera'

describe 'vision_webshop::docker' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      # Default check to see if manifest compiles
      context 'compile' do
        it { is_expected.to compile.with_all_deps }
      end
      context 'contains' do
        it { is_expected.to contain_docker__image('webshop').with_image_tag('latest') }
      end
    end
  end
end

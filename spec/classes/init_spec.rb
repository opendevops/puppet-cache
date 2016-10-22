require 'spec_helper'
describe 'cache' do

  context 'with defaults for all parameters' do
    it { should contain_class('cache') }
  end
end

require File.expand_path('../motion_stub.rb', __FILE__)
require 'bubble-wrap'

describe BubbleWrap do
  describe '.root' do
    it 'returns an absolute path' do
      BubbleWrap.root[0].should == '/'
    end
  end

  describe '.require' do
    it 'delegates to Requirement.scan' do
      BW::Requirement.should_receive(:scan)
      BW.require('foo')
    end
  end
end

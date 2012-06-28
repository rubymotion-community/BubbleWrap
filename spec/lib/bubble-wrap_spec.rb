require 'mocha-on-bacon'
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
      BW::Requirement.expects(:scan)
      BW.require('foo')
    end

    it 'finds files with relative paths' do
      BW::Requirement.clear!
      BW.require '../motion/core.rb'
      BW::Requirement.files.member?(File.expand_path('../../../motion/core.rb', __FILE__)).should == true
    end 

    it 'finds files with absolute paths' do
      BW::Requirement.clear!
      BW.require File.expand_path('../../../motion/core.rb', __FILE__)
      BW::Requirement.files.member?(File.expand_path('../../../motion/core.rb', __FILE__)).should == true
    end
  end
end

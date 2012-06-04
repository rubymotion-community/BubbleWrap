describe 'Motion guard' do
  context 'when Motion is not present' do
    it 'raises an exception' do
      proc do
        require 'bubble-wrap'
      end.should raise_error
    end
  end

  context 'when Motion is present' do
    before do
      require File.expand_path('../motion_stub', __FILE__)
    end

    it "doesn't raise an exception" do
      proc do 
        require 'bubble-wrap'
      end.should_not raise_error
    end
  end
end

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

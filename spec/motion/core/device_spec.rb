describe BubbleWrap::Device do

  describe '.screen' do
    it 'return BubbleWrap::Screen' do
      BW::Device.screen.should == BW::Device::Screen
    end
  end

  describe '.retina?' do
    it 'delegates to BubbleWrap::Screen.retina?' do
      BW::Device.retina?.should == BW::Device::Screen.retina?
    end
  end
end

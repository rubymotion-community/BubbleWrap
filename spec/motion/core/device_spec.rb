describe BubbleWrap::Device do

  describe 'on iPhone' do
    before do
      @idiom = UIUserInterfaceIdiomPhone
    end

    describe '.iphone?' do
      it 'returns true' do
        BW::Device.iphone?(@idiom).should == true
      end
    end

    describe '.ipad?' do
      it 'returns false' do
        BW::Device.ipad?(@idiom).should == false
      end
    end

    describe '.long_screen?' do
      it 'returns true if screen is wide' do
        BW::Device.long_screen?(@idiom, 568.0).should == true
      end

      it 'returns false if screen is not wide' do
        BW::Device.long_screen?(@idiom, 480.0).should == false
      end
    end
  end

  describe 'on iPad' do
    before do
      @idiom = UIUserInterfaceIdiomPad
    end

    describe '.iphone?' do
      it 'returns false' do
        BW::Device.iphone?(@idiom).should == false
      end
    end

    describe '.ipad?' do
      it 'returns true' do
        BW::Device.ipad?(@idiom).should == true
      end
    end

    describe '.long_screen?' do
      it 'always not a widescreen' do
        BW::Device.long_screen?(@idiom, 1024.0).should == false
      end
    end
  end

  describe '.simulator?' do
    it 'returns true' do
      BW::Device.simulator?.should == true
    end
  end

  describe '.ios_version' do
    it 'returns true' do
      # exact value depends on system where specs run. 4.0 seems like a safe guess
      BW::Device.ios_version.should > '4.0'
    end
  end

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

  describe '.orientation' do
    it 'delegates to BubbleWrap::Screen.orientation' do
      BW::Device.orientation.should == BW::Device::Screen.orientation
    end
  end
end

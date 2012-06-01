describe BubbleWrap::Device::Screen do

  describe 'on retina enabled screen' do
    before do
      @screen = Object.new.tap do |o|
        def o.respondsToSelector(selector)
          return true if selector == 'displayLinkWithTarget:selector:'
          UIDevice.mainDevice.respondsToSelector(selector)
        end
        def o.scale
          2.0
        end
        def o.method_missing(*args)
          UIDevice.mainDevice.send(*args)
        end
      end
    end

    describe '.retina?' do
      it 'returns true' do
        BW::Device::Screen.retina?(@screen).should == true
      end
    end
  end

  describe 'on non-retina enabled screen' do
    before do
      @screen = Object.new.tap do |o|
        def o.respondsToSelector(selector)
          return false if selector == 'displayLinkWithTarget:selector:'
          UIDevice.mainDevice.respondsToSelector(selector)
        end
        def o.scale
          1.0
        end
        def o.method_missing(*args)
          UIDevice.mainDevice.send(*args)
        end
      end
    end

    describe '.retina?' do
      it 'returns false' do
        BW::Device::Screen.retina?(@screen).should == false
      end
    end
  end

  describe '.orientation' do

    describe 'portrait' do
      it 'returns :portrait' do
        BW::Device::Screen.orientation(UIDeviceOrientationPortrait).should == :portrait
      end
    end

    describe 'portrait upside down' do
      it 'returns :portrait_upside_down' do
        BW::Device::Screen.orientation(UIDeviceOrientationPortraitUpsideDown).should == :portrait_upside_down
      end
    end

    describe 'landscape left' do
      it 'returns :landscape_left' do
        BW::Device::Screen.orientation(UIDeviceOrientationLandscapeLeft).should == :landscape_left
      end
    end

    describe 'landscape right' do
      it 'returns :landscape_right' do
        BW::Device::Screen.orientation(UIDeviceOrientationLandscapeRight).should == :landscape_right
      end
    end

    describe 'face up' do
      it 'returns :face_up' do
        BW::Device::Screen.orientation(UIDeviceOrientationFaceUp).should == :face_up
      end
    end

    describe 'face down' do
      it 'returns :face_down' do
        BW::Device::Screen.orientation(UIDeviceOrientationFaceDown).should == :face_down
      end
    end

    describe 'unknown' do
      it 'returns :unknown' do
        BW::Device::Screen.orientation(UIDeviceOrientationUnknown).should == :unknown
      end
    end

    describe 'any other input' do
      it 'returns :unknown' do
        BW::Device::Screen.orientation('twiggy twiggy twiggy').should == :unknown
      end
    end
  end

  describe '.width' do
    it 'returns the current device screen width' do
      BW::Device::Screen.width.should == 320.0 if BW::Device.iphone?
      BW::Device::Screen.width.should == 768.0 if BW::Device.ipad?
    end
  end

  describe '.height' do
    it 'returns the current device screen height' do
      BW::Device::Screen.height.should == 480.0 if BW::Device.iphone?
      BW::Device::Screen.height.should == 1024.0 if BW::Device.ipad?
    end
  end

  describe '.widthForOrientation' do
    describe ':landscape_left' do
      it 'returns the current device screen height' do
        BW::Device::Screen.widthForOrientation(:landscape_left).should == BW::Device::Screen.height
      end
    end

    describe ':landscape_right' do
      it 'returns the current device screen height' do
        BW::Device::Screen.widthForOrientation(:landscape_right).should == BW::Device::Screen.height
      end
    end

    describe 'default' do
      it 'returns the current device screen width' do
        BW::Device::Screen.widthForOrientation.should == BW::Device::Screen.width
      end
    end
  end

  describe '.heightForOrientation' do
    describe ':landscape_left' do
      it 'returns the current device screen width' do
        BW::Device::Screen.heightForOrientation(:landscape_left).should == BW::Device::Screen.width
      end
    end

    describe ':landscape_right' do
      it 'returns the current device screen width' do
        BW::Device::Screen.heightForOrientation(:landscape_right).should == BW::Device::Screen.width
      end
    end

    describe 'default' do
      it 'returns the current device screen height' do
        BW::Device::Screen.heightForOrientation.should == BW::Device::Screen.height
      end
    end
  end
end

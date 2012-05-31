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
  end

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
        BW::Device.retina?(@screen).should == true
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
        BW::Device.retina?(@screen).should == false
      end
    end
  end

  describe 'on device with only front facing camera' do
    before do 
      @picker = Object.new.tap do |o|
        def o.isCameraDeviceAvailable(c)
          c == UIImagePickerControllerCameraDeviceFront
        end
        def o.method_missing(*args)
          UIImagePickerController.send(*args)
        end
      end
    end

    describe '.front_camera?' do
      it 'returns true' do
        BW::Device.front_camera?(@picker).should == true
      end
    end

    describe '.rear_camera?' do
      it 'returns false' do
        BW::Device.rear_camera?(@picker).should == false
      end
    end
  end

  describe 'on device with only rear facing camera' do
    before do 
      @picker = Object.new.tap do |o|
        def o.isCameraDeviceAvailable(c)
          c == UIImagePickerControllerCameraDeviceRear
        end
        def o.method_missing(*args)
          UIImagePickerController.send(*args)
        end
      end
    end

    describe '.front_camera?' do
      it 'returns false' do
        BW::Device.front_camera?(@picker).should == false
      end
    end

    describe '.rear_camera?' do
      it 'returns true' do
        BW::Device.rear_camera?(@picker).should == true
      end
    end
  end

  describe '.orientation' do

    describe 'portrait' do
      it 'returns :portrait' do
        BW::Device.orientation(UIDeviceOrientationPortrait).should == :portrait
      end
    end

    describe 'portrait upside down' do
      it 'returns :portrait_upside_down' do
        BW::Device.orientation(UIDeviceOrientationPortraitUpsideDown).should == :portrait_upside_down
      end
    end

    describe 'landscape left' do
      it 'returns :landscape_left' do
        BW::Device.orientation(UIDeviceOrientationLandscapeLeft).should == :landscape_left
      end
    end

    describe 'landscape right' do
      it 'returns :landscape_right' do
        BW::Device.orientation(UIDeviceOrientationLandscapeRight).should == :landscape_right
      end
    end

    describe 'face up' do
      it 'returns :face_up' do
        BW::Device.orientation(UIDeviceOrientationFaceUp).should == :face_up
      end
    end

    describe 'face down' do
      it 'returns :face_down' do
        BW::Device.orientation(UIDeviceOrientationFaceDown).should == :face_down
      end
    end

    describe 'unknown' do
      it 'returns :unknown' do
        BW::Device.orientation(UIDeviceOrientationUnknown).should == :unknown
      end
    end

    describe 'any other input' do
      it 'returns :unknown' do
        BW::Device.orientation('twiggy twiggy twiggy').should == :unknown
      end
    end
  end

  describe '.simulator?' do
    it 'returns true' do
      BW::Device.simulator?.should == true
    end
  end
end

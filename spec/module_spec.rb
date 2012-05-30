describe BubbleWrap do

  describe 'on iPhone' do
    before do
      @idiom = UIUserInterfaceIdiomPhone
    end

    describe '.iphone?' do
      it 'returns true' do
        BW.iphone?(@idiom).should == true
      end
    end

    describe '.ipad?' do
      it 'returns false' do
        BW.ipad?(@idiom).should == false
      end
    end
  end

  describe 'on iPad' do
    before do
      @idiom = UIUserInterfaceIdiomPad
    end

    describe '.iphone?' do
      it 'returns false' do
        BW.iphone?(@idiom).should == false
      end
    end

    describe '.ipad?' do
      it 'returns true' do
        BW.ipad?(@idiom).should == true
      end
    end
  end

  describe 'on retina enabled screen' do
    before do
      @screen = Object.new.tap do |o|
        def o.respondsToSelector(selector)
          return true if selector == 'displayLinkWithTarget:selector:'
          UIScreen.mainScreen.respondsToSelector(selector)
        end
        def o.scale
          2.0
        end
        def o.method_missing(*args)
          UIScreen.mainScreen.send(*args)
        end
      end
    end

    describe '.retina?' do
      it 'returns true' do
        BW.retina?(@screen).should == true
      end
    end
  end

  describe 'on non-retina enabled screen' do
    before do
      @screen = Object.new.tap do |o|
        def o.respondsToSelector(selector)
          return false if selector == 'displayLinkWithTarget:selector:'
          UIScreen.mainScreen.respondsToSelector(selector)
        end
        def o.scale
          1.0
        end
        def o.method_missing(*args)
          UIScreen.mainScreen.send(*args)
        end
      end
    end

    describe '.retina?' do
      it 'returns false' do
        BW.retina?(@screen).should == false
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
        BW.front_camera?(@picker).should == true
      end
    end

    describe '.rear_camera?' do
      it 'returns false' do
        BW.rear_camera?(@picker).should == false
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
        BW.front_camera?(@picker).should == false
      end
    end

    describe '.rear_camera?' do
      it 'returns true' do
        BW.rear_camera?(@picker).should == true
      end
    end
  end

  describe '.documents_path' do
    it 'should end in "/Documents"' do
      BW.documents_path[-10..-1].should == '/Documents'
    end
  end

  describe '.resources_path' do 
    it 'should end in "/MotionLibTestSuite.app"' do
      BW.resources_path[-23..-1].should == '/MotionLibTestSuite.app'
    end
  end

  describe '.orientation' do

    describe 'portrait' do
      it 'returns :portrait' do
        BW.orientation(UIDeviceOrientationPortrait).should == :portrait
      end
    end

    describe 'portrait upside down' do
      it 'returns :portrait_upside_down' do
        BW.orientation(UIDeviceOrientationPortraitUpsideDown).should == :portrait_upside_down
      end
    end

    describe 'landscape left' do
      it 'returns :landscape_left' do
        BW.orientation(UIDeviceOrientationLandscapeLeft).should == :landscape_left
      end
    end

    describe 'landscape right' do
      it 'returns :landscape_right' do
        BW.orientation(UIDeviceOrientationLandscapeRight).should == :landscape_right
      end
    end

    describe 'face up' do
      it 'returns :face_up' do
        BW.orientation(UIDeviceOrientationFaceUp).should == :face_up
      end
    end

    describe 'face down' do
      it 'returns :face_down' do
        BW.orientation(UIDeviceOrientationFaceDown).should == :face_down
      end
    end

    describe 'unknown' do
      it 'returns :unknown' do
        BW.orientation(UIDeviceOrientationUnknown).should == :unknown
      end
    end

    describe 'any other input' do
      it 'returns :unknown' do
        BW.orientation('twiggy twiggy twiggy').should == :unknown
      end
    end

  end

end

module BubbleWrap
  module Device
    module_function

    # Verifies that the device running the app is an iPhone.
    # @return [TrueClass, FalseClass] true will be returned if the device is an iPhone, false otherwise.
    def iphone?(idiom=UIDevice.currentDevice.userInterfaceIdiom)
      idiom == UIUserInterfaceIdiomPhone
    end
    
    # Verifies that the device running the app is an iPhone X.
    # @return [TrueClass, FalseClass] true will be returned if the device is an iPhone X, false otherwise.
    def iphonex?(idiom=UIDevice.currentDevice.userInterfaceIdiom)
      (idiom == UIUserInterfaceIdiomPhone) && [UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width].max==812.0
    end
    
    # Verifies that the device running the app is an iPad.
    # @return [TrueClass, FalseClass] true will be returned if the device is an iPad, false otherwise.
    def ipad?(idiom=UIDevice.currentDevice.userInterfaceIdiom)
      idiom == UIUserInterfaceIdiomPad
    end

    # Verifies that the device having a long screen (4 inch iPhone/iPod)
    # @return [TrueClass, FalseClass] true will be returned if the device is an iPhone/iPod with 4 inche screen, false otherwise.
    def long_screen?(idiom=UIDevice.currentDevice.userInterfaceIdiom, screen_height=UIScreen.mainScreen.bounds.size.height)
      iphone?(idiom) && [UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width].max == 568.0
    end

    # Use this to make a DSL-style call for picking images
    # @example Device.camera.front
    # @return [Device::Camera::CameraWrapper]
    def camera
      BubbleWrap::Device::CameraWrapper
    end

    # Verifies that the device running has a front facing camera.
    # @return [TrueClass, FalseClass] true will be returned if the device has a front facing camera, false otherwise.
    def front_camera?(picker=UIImagePickerController)
      p "This method (front_camera?) is DEPRECATED. Transition to using Device.camera.front?"
      picker.isCameraDeviceAvailable(UIImagePickerControllerCameraDeviceFront)
    end

    # Verifies that the device running has a rear facing camera.
    # @return [TrueClass, FalseClass] true will be returned if the device has a rear facing camera, false otherwise.
    def rear_camera?(picker=UIImagePickerController)
      p "This method (rear_camera?) is DEPRECATED. Transition to using Device.camera.rear?"
      picker.isCameraDeviceAvailable(UIImagePickerControllerCameraDeviceRear)
    end

    # Return whether app is being run in simulator
    # @return [TrueClass, FalseClass] true will be returned if simulator, false otherwise.
    def simulator?
      @simulator_state ||= begin
        if ios_version.to_i >= 9
          NSBundle.mainBundle.bundlePath !~ /^(\/private)?\/var/
        else
          !(UIDevice.currentDevice.model =~ /simulator/i).nil?
        end
      end
    end

    def force_touch?
      if defined?(UIForceTouchCapabilityAvailable) && defined?(UIScreen.mainScreen.traitCollection) && defined?(UIScreen.mainScreen.traitCollection.forceTouchCapability)
        UIScreen.mainScreen.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable
      else
        false
      end
    end

    # Returns the IOS SDK version currently running (i.e. "5.1" or "6.0" etc)
    # @return [String] the IOS SDK version currently running
    def ios_version
      UIDevice.currentDevice.systemVersion
    end

    # Returns an identifier unique to the vendor across the vendors app.
    # @return [NSUUID]
    def vendor_identifier
      UIDevice.currentDevice.identifierForVendor
    end

    # Delegates to BubbleWrap::Screen.orientation
    def orientation
      screen.orientation
    end

    # Delegates to BubbleWrap::Screen.interface_orientation
    def interface_orientation
      screen.interface_orientation
    end
  end
end

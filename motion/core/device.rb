module BubbleWrap
  module Device
    module_function

    # Verifies that the device running the app is an iPhone.
    # @return [TrueClass, FalseClass] true will be returned if the device is an iPhone, false otherwise.
    def iphone?(idiom=UIDevice.currentDevice.userInterfaceIdiom)
      idiom == UIUserInterfaceIdiomPhone
    end

    # Verifies that the device running the app is an iPad.
    # @return [TrueClass, FalseClass] true will be returned if the device is an iPad, false otherwise.
    def ipad?(idiom=UIDevice.currentDevice.userInterfaceIdiom)
      idiom == UIUserInterfaceIdiomPad
    end
    
    # Verifies that the device having a long screen (4 inch iPhone/iPod)
    # @return [TrueClass, FalseClass] true will be returned if the device is an iPhone/iPod with 4 inche screen, false otherwise.
    def long_screen?(idiom=UIDevice.currentDevice.userInterfaceIdiom, screen_height=UIScreen.mainScreen.bounds.size.height)
      iphone?(idiom) && screen_height == 568.0
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

    def simulator?
      @simulator_state ||= !(UIDevice.currentDevice.model =~ /simulator/i).nil?
    end

    # Returns the IOS SDK version currently running (i.e. "5.1" or "6.0" etc)
    # @return [String] the IOS SDK version currently running
    def ios_version
      UIDevice.currentDevice.systemVersion
    end

    # Shameless shorthand for accessing BubbleWrap::Screen
    def screen
      BubbleWrap::Device::Screen
    end

    # Delegates to BubbleWrap::Screen.retina?
    def retina?
      screen.retina?
    end

    # Delegates to BubbleWrap::Screen.orientation
    def orientation
      screen.orientation
    end

  end
end
::Device = BubbleWrap::Device unless defined?(::Device)

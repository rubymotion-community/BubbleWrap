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

    # Verifies that the device running has a front facing camera.
    # @return [TrueClass, FalseClass] true will be returned if the device has a front facing camera, false otherwise.
    def front_camera?(picker=UIImagePickerController)
      picker.isCameraDeviceAvailable(UIImagePickerControllerCameraDeviceFront)
    end

    # Verifies that the device running has a rear facing camera.
    # @return [TrueClass, FalseClass] true will be returned if the device has a rear facing camera, false otherwise.
    def rear_camera?(picker=UIImagePickerController)
      picker.isCameraDeviceAvailable(UIImagePickerControllerCameraDeviceRear)
    end
    
    # Verifies that the device running has a front facing flash.
    # @return [TrueClass, FalseClass] true will be returned if the device has a front facing flash, false otherwise
    def front_camera_flash?(picker=UIImagePickerController)
      picker.isFlashAvailableForCameraDevice(UIImagePickerControllerCameraDeviceFront)
    end
    
    # Verifies that the device running has a rear facing flash.
    # @return [TrueClass, FalseClass] true will be returned if the device has a rear facing flash, false otherwise
    def rear_camera_flash?(picker=UIImagePickerController)
      picker.isFlashAvailableForCameraDevice(UIImagePickerControllerCameraDeviceRear)
    end

    def simulator?
      @simulator_state ||= !(UIDevice.currentDevice.model =~ /simulator/i).nil?
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
::Device = BubbleWrap::Device

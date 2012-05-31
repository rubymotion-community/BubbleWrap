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

    # Certifies that the device running the app has a Retina display
    # @return [TrueClass, FalseClass] true will be returned if the device has a Retina display, false otherwise.
    def retina?(screen=UIScreen.mainScreen)
      if screen.respondsToSelector('displayLinkWithTarget:selector:') && screen.scale == 2.0
        true
      else
        false
      end
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

    def simulator?
      @simulator_state ||= !(UIDevice.currentDevice.model =~ /simulator/i).nil?
    end

    def orientation(device_orientation=UIDevice.currentDevice.orientation)
      case device_orientation
      when UIDeviceOrientationPortrait then :portrait
      when UIDeviceOrientationPortraitUpsideDown then :portrait_upside_down
      when UIDeviceOrientationLandscapeLeft then :landscape_left
      when UIDeviceOrientationLandscapeRight then :landscape_right
      when UIDeviceOrientationFaceUp then :face_up
      when UIDeviceOrientationFaceDown then :face_down
      else
        :unknown
      end
    end

  end
end
::Device = BubbleWrap::Device

module Motion
  module Kernel
    
    # Verifies that the device running the app is an iPhone.
    # @return [TrueClass, FalseClass] true will be returned if the device is an iPhone, false otherwise.
    def iphone?
      UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone
    end

    # Verifies that the device running the app is an iPad.
    # @return [TrueClass, FalseClass] true will be returned if the device is an iPad, false otherwise.
    def ipad?
      UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad
    end

    # Returns the application's document directory path where users might be able to upload content.
    # @return [String] the path to the document directory
    def documents_path
      NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0]
    end

    def app_delegate
      UIApplication.sharedApplication.delegate
    end

    def orientation
      case UIDevice.currentDevice.orientation
      when UIDeviceOrientationUnknown then :unknown
      when UIDeviceOrientationPortrait then :portrait
      when UIDeviceOrientationPortraitUpsideDown then :upside_down_portrait
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

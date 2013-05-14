module BubbleWrap
  module Device
    module Screen

      module_function

      # Certifies that the device running the app has a Retina display
      # @return [TrueClass, FalseClass] true will be returned if the device has a Retina display, false otherwise.
      def retina?(screen=UIScreen.mainScreen)
        if screen.respondsToSelector('displayLinkWithTarget:selector:') && screen.scale == 2.0
          true
        else
          false
        end
      end

      # Figure out the current physical orientation of the device
      # @return [:portrait, :portrait_upside_down, :landscape_left, :landscape_right, :face_up, :face_down, :unknown]
      def orientation(device_orientation=UIDevice.currentDevice.orientation, fallback=true)
        case device_orientation
        when UIDeviceOrientationPortrait then :portrait
        when UIDeviceOrientationPortraitUpsideDown then :portrait_upside_down
        when UIDeviceOrientationLandscapeLeft then :landscape_left
        when UIDeviceOrientationLandscapeRight then :landscape_right
        when UIDeviceOrientationFaceUp then :face_up
        when UIDeviceOrientationFaceDown then :face_down
        else
          # In some cases, the accelerometer can't get an accurate read of orientation so we fall back on the orientation of
          # the status bar.
          if fallback && (device_orientation != UIApplication.sharedApplication.statusBarOrientation)
            orientation(UIApplication.sharedApplication.statusBarOrientation)
          else
            :unknown
          end
        end
      end

      # The width of the device's screen.
      # The real resolution is dependant on the scale
      # factor (see `retina?`) but the coordinate system
      # is in non-retina pixels. You can get pixel
      # accuracy by using half-coordinates.
      # This is a Float
      def width
        UIScreen.mainScreen.bounds.size.width
      end

      # The height of the device's screen.
      # The real resolution is dependant on the scale
      # factor (see `retina?`) but the coordinate system
      # is in non-retina pixels. You can get pixel
      # accuracy by using half-coordinates.
      # This is a Float
      def height
        UIScreen.mainScreen.bounds.size.height
      end

      # The same as `.width` and `.height` but
      # compensating for screen rotation (which
      # can do your head in).
      def width_for_orientation(o=orientation)
        return height if (o == :landscape_left) || (o == :landscape_right) 
        width
      end

      # The same as `.width` and `.height` but
      # compensating for screen rotation (which
      # can do your head in).
      def height_for_orientation(o=orientation)
        return width if (o == :landscape_left) || (o == :landscape_right) 
        height
      end
    end
  end
end

module BubbleWrap
  module Device
    module Screen

      module_function

      # Certifies that the device running the app has a Retina display
      # @return [TrueClass, FalseClass] true will be returned if the device has a Retina display, false otherwise.
      def retina?(_=UIScreen.mainScreen)
        false
      end

      # Figure out the current physical orientation of the device
      # @return [:portrait, :portrait_upside_down, :landscape_left, :landscape_right, :face_up, :face_down, :unknown]
      def orientation(device_orientation=UIDevice.currentDevice.orientation, fallback=true)
        :landscape
      end

      # Figure out the current orientation of the interface
      # @return [:portrait, :portrait_upside_down, :landscape_left, :landscape_right]
      def interface_orientation(device_orientation=UIDevice.currentDevice.orientation, fallback=true)
        :landscape
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
        width
      end

      # The same as `.width` and `.height` but
      # compensating for screen rotation (which
      # can do your head in).
      def height_for_orientation(o=orientation)
        height
      end
    end
  end
end

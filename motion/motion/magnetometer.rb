module BubbleWrap
  module Motion
    class Magnetometer < GenericMotionInterface

      def start(options={}, &handler)
        if options.key?(:interval)
          @manager.magnetometerUpdateInterval = options[:interval]
        end

        if handler
          queue = convert_queue(options[:queue])
          @manager.startMagnetometerUpdatesToQueue(queue, withHandler: internal_handler(handler))
        else
          @manager.startMagnetometerUpdates
        end

        return self
      end

      private def handle_result(result_data, error, handler)
        if result_data
          result = {
            data: result_data,
            field: result_data.magneticField,
            x: result_data.magneticField.x,
            y: result_data.magneticField.y,
            z: result_data.magneticField.z,
          }
        else
          result = nil
        end

        handler.call(result, error)
      end

      def available?
        @manager.magnetometerAvailable?
      end

      def active?
        @manager.magnetometerActive?
      end

      def data
        @manager.magnetometerData
      end

      def stop
        @manager.stopMagnetometerUpdates
      end

    end

  end
end

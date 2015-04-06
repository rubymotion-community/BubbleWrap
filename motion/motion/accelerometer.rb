module BubbleWrap
  module Motion
    class Accelerometer < GenericMotionInterface

      def start(options={}, &handler)
        if options.key?(:interval)
          @manager.accelerometerUpdateInterval = options[:interval]
        end

        if handler
          queue = convert_queue(options[:queue])
          @manager.startAccelerometerUpdatesToQueue(queue, withHandler: internal_handler(handler))
        else
          @manager.startAccelerometerUpdates
        end

        return self
      end

      private def handle_result(result_data, error, handler)
        if result_data
          result = {
            data: result_data,
            acceleration: result_data.acceleration,
            x: result_data.acceleration.x,
            y: result_data.acceleration.y,
            z: result_data.acceleration.z,
          }
        else
          result = nil
        end

        handler.call(result, error)
      end

      def available?
        @manager.accelerometerAvailable?
      end

      def active?
        @manager.accelerometerActive?
      end

      def data
        @manager.accelerometerData
      end

      def stop
        @manager.stopAccelerometerUpdates
      end

    end

  end
end

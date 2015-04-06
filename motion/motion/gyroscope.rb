module BubbleWrap
  module Motion
    class Gyroscope < GenericMotionInterface

      def start(options={}, &handler)
        if options.key?(:interval)
          @manager.gyroUpdateInterval = options[:interval]
        end

        if handler
          queue = convert_queue(options[:queue])
          @manager.startGyroUpdatesToQueue(queue, withHandler: internal_handler(handler))
        else
          @manager.startGyroUpdates
        end

        return self
      end

      private def handle_result(result_data, error, handler)
        if result_data
          result = {
            data: result_data,
            rotation: result_data.rotationRate,
            x: result_data.rotationRate.x,
            y: result_data.rotationRate.y,
            z: result_data.rotationRate.z,
          }
        else
          result = nil
        end

        handler.call(result, error)
      end

      def available?
        @manager.gyroAvailable?
      end

      def active?
        @manager.gyroActive?
      end

      def data
        @manager.gyroData
      end

      def stop
        @manager.stopGyroUpdates
      end

    end

  end
end

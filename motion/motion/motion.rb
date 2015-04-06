# Provides a nice DSL for interacting with the standard CMMotionManager from
# CoreMotion
module BubbleWrap
  # These module methods provide the main interface.  It uses a shared manager
  # (per Apple's recommendation), and they all have a common set of supported
  # methods:
  #     available?
  #     active?
  #     repeat(opts)
  #     once(opts)
  #     every(time_interval, opts)
  #
  # @example
  #     if BW::Motion.accelerometer.available?
  #       BW::Motion.accelerometer.every(5) do |result|
  #         # see the README for the keys that are available in result.
  #       end
  #     end
  #
  # If you insist on using your own manager, or you want more than one
  # BW::Motion::Whatever running at the same time, you'll need to instantiate
  # them yourself.
  #
  # @example
  #     mgr = CMMotionManager.alloc.init
  #     accel = BW::Motion::Accelerometer.new(mgr)
  #     accel.once do |result_data|
  #     end
  #     # => BW::Motion::accelerometer.once do |result_data| ... end
  module Motion
    module_function

    def manager
      @manager ||= CMMotionManager.alloc.init
    end

    def accelerometer
      @accelerometer ||= Accelerometer.new(self.manager)
    end

    def gyroscope
      @gyroscope ||= Gyroscope.new(self.manager)
    end

    def magnetometer
      @magnetometer ||= Magnetometer.new(self.manager)
    end

    def device
      @device ||= DeviceMotion.new(self.manager)
    end
  end


  module Motion
    module Error
    end

    class GenericMotionInterface

      def initialize(manager)
        @manager = manager
      end

      def repeat(options={}, &blk)
        raise "A block is required" unless blk
        blk.weak! if BubbleWrap.use_weak_callbacks?

        self.start(options, &blk)
        return self
      end

      def every(time=nil, options={}, &blk)
        raise "A block is required" unless blk
        blk.weak! if BubbleWrap.use_weak_callbacks?

        if time.is_a?(NSDictionary)
          options = time
        elsif time
          options = options.merge(interval: time)
        end

        self.start(options, &blk)
        return self
      end

      def once(options={}, &blk)
        raise "A block is required" unless blk
        blk.weak! if BubbleWrap.use_weak_callbacks?

        @called_once = false
        every(options) do |result, error|
          unless @called_once
            @called_once = true
            blk.call(result, error)
          end
          self.stop
        end

        return self
      end

      private def convert_queue(queue_name)
        case queue_name
        when :main, nil
          return NSOperationQueue.mainQueue
        when :background
          queue = NSOperationQueue.new
          queue.name = 'com.bubble-wrap.core-motion.background-queue'
          return queue
        when :current
          return NSOperationQueue.currentQueue
        when String
          queue = NSOperationQueue.new
          queue.name = queue_name
          return queue
        else
          queue_name
        end
      end

      private def internal_handler(handler)
        retval = -> (result_data, error) do
          handle_result(result_data, error, handler)
        end
        retval.weak! if BubbleWrap.use_weak_callbacks?
        retval
      end

    end

  end
end

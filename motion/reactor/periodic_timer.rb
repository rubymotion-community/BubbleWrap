module BubbleWrap
  module Reactor
    # Creates a repeating timer.
    class PeriodicTimer
      include Eventable

      attr_accessor :interval

      # Create a new timer that fires after a given number of seconds
      def initialize(interval, *args, &blk)
        callback = args.first.respond_to?(:call) ? args.first : blk
        raise ArgumentError, "No callback or block supplied to periodic timer" unless callback
        callback.weak! if callback && BubbleWrap.use_weak_callbacks?

        options = args.last.is_a?(Hash) ? args.last : {}
        if options[:common_modes]
          NSLog "[DEPRECATED - Option :common_modes] a Run Loop Mode is no longer needed."
        end

        self.interval = interval

        leeway = interval
        queue  = Dispatch::Queue.current
        @timer = Dispatch::Source.timer(leeway, interval, 0.0, queue) do
          callback.call
          trigger(:fired)
        end
      end

      # Cancel the timer
      def cancel
        @timer.cancel!
        trigger(:cancelled)
      end

    end
  end
end

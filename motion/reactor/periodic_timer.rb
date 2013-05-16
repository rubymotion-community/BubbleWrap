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

        self.interval = interval
        fire = proc {
          callback.call
          trigger(:fired)
        }
        queue  = Dispatch::Queue.current
        @timer = Dispatch::Source.timer(interval, interval, 0.0, queue, &fire)
      end

      # Cancel the timer
      def cancel
        @timer.cancel!
        trigger(:cancelled)
      end

    end
  end
end

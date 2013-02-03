module BubbleWrap
  module Reactor
    # Creates a repeating timer.
    class PeriodicTimer
      include Eventable

      attr_accessor :interval

      # Create a new timer that fires after a given number of seconds
      def initialize(interval, *args, &blk)
        options = args.last.is_a?(Hash) ? args.last : {}
        callback = args.first.respond_to?(:call) ? args.first : blk
        raise ArgumentError, "No callback or block supplied to periodic timer" unless callback

        self.interval = interval
        fire = proc {
          callback.call
          trigger(:fired)
        }
        @timer = NSTimer.timerWithTimeInterval(interval, target: fire, selector: 'call:', userInfo: nil, repeats: true)
        runloop_mode = options[:common_modes] ? NSRunLoopCommonModes : NSDefaultRunLoopMode 
        NSRunLoop.currentRunLoop.addTimer(@timer, forMode: runloop_mode)
      end

      # Cancel the timer
      def cancel
        @timer.invalidate
        trigger(:cancelled)
      end

    end
  end
end

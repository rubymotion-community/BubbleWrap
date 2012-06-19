module BubbleWrap
  module Reactor
    # Creates a repeating timer.
    class PeriodicTimer
      include Eventable

      attr_accessor :interval

      # Create a new timer that fires after a given number of seconds
      def initialize(interval, callback=nil, &blk)
        self.interval = interval
        fire = proc {
          (callback || blk).call
          trigger(:fired)
        }
        @timer = NSTimer.scheduledTimerWithTimeInterval(interval,target: fire, selector: 'call:', userInfo: nil, repeats: true)
      end

      # Cancel the timer
      def cancel
        @timer.invalidate
        trigger(:cancelled)
      end

    end
  end
end

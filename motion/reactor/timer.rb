module BubbleWrap
  module Reactor
    # Creates a one-time timer.
    class Timer
      include Eventable

      # Create a new timer that fires after a given number of seconds
      def initialize(interval, callback=nil, &blk)
        fire = proc {
          (callback || blk).call
          trigger(:fired)
        }
        @timer = NSTimer.scheduledTimerWithTimeInterval(interval,target: fire, selector: 'call:', userInfo: nil, repeats: false)
      end

      # Cancel the timer
      def cancel
        @timer.invalidate
        trigger(:cancelled)
        true
      end

    end
  end
end

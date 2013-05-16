module BubbleWrap
  module Reactor
    # Creates a one-time timer.
    class Timer
      include Eventable

      # Create a new timer that fires after a given number of seconds
      def initialize(interval, callback=nil, &blk)
        queue  = Dispatch::Queue.current
        @timer = Dispatch::Source.timer(interval, interval, 0.0, queue) do |src|
          (callback || blk).call
          trigger(:fired)
          src.cancel!
        end        
      end

      # Cancel the timer
      def cancel
        @timer.cancel!
        @timer = nil
        trigger(:cancelled)
        true
      end

    end
  end
end

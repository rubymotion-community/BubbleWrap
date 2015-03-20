module BubbleWrap
  module Reactor
    # Creates a one-time timer.
    class Timer
      include Eventable

      # Create a new timer that fires after a given number of seconds
      def initialize(leeway, callback=nil, &blk)
        queue  = Dispatch::Queue.current
        @timer = Dispatch::Source.timer(leeway, Dispatch::TIME_FOREVER, 0.0, queue) do |src|
          begin
            (callback || blk).call
            trigger(:fired)
          ensure
            src.cancel!
          end
        end
      end

      # Cancel the timer
      def cancel
        @timer.cancel! if @timer
        trigger(:cancelled)
        true
      end

    end
  end
end

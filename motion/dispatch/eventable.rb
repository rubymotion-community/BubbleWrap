module BubbleWrap
  module Dispatch
    module Eventable

      def on(event, &blk)
        @events ||= Hash.new { [] }
        @events[event].unshift blk
      end

      def trigger(event, *args)
        @events ||= Hash.new { [] }
        @events[event].map do |event|
          event.call(*args)
        end
      end

    end
  end
end

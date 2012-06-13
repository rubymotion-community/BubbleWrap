module BubbleWrap
  module Dispatch
    # A simple mixin that adds events to your object.
    module Eventable

      # When `event` is triggered the block will execute
      # and be passed the arguments that are passed to
      # `trigger`.
      def on(event, &blk)
        @events ||= Hash.new { |h,k| h[k] = [] }
        @events[event].push blk
      end

      # Trigger an event
      def trigger(event, *args)
        @events ||= Hash.new { |h,k| h[k] = [] }
        @events[event].map do |event|
          event.call(*args)
        end
      end

    end
  end
end

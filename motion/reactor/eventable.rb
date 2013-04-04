module BubbleWrap
  module Reactor
    # A simple mixin that adds events to your object.
    module Eventable

      # When `event` is triggered the block will execute
      # and be passed the arguments that are passed to
      # `trigger`.
      def on(event, &blk)
        events[event].push blk
      end

      # When `event` is triggered, do not call the given
      # block any more
      def off(event, &blk)
        events[event].delete_if { |b| b == blk }
        blk
      end

      # Trigger an event
      def trigger(event, *args)
        events[event].map do |event|
          event.call(*args)
        end
      end

      private

      def events
        @events ||= Hash.new { |h,k| h[k] = [] }
      end
    end
  end
end

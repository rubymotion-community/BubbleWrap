module BubbleWrap
  module Reactor
    # A simple mixin that adds events to your object.
    module Eventable

      # When `event` is triggered the block will execute
      # and be passed the arguments that are passed to
      # `trigger`.
      def on(event, &blk)
        __events__[event].push blk
      end

      # When `event` is triggered, do not call the given
      # block any more
      def off(event, &blk)
        __events__[event].delete_if { |b| b == blk }
        blk
      end

      # Trigger an event
      def trigger(event, *args)
        blks = __events__[event].clone
        blks.map do |blk|
          blk.call(*args)
        end
      end

      private

      def __events__
        @__events__ ||= Hash.new { |h,k| h[k] = [] }
      end
    end
  end
end

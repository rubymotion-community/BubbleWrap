module BubbleWrap
  module Reactor
    # A simple mixin that adds events to your object.
    module Eventable

      # When `event` is triggered the block will execute
      # and be passed the arguments that are passed to
      # `trigger`.
      def on(event, method = nil, &blk)
        events = _events_for_key(event)
        if method
          events.push method if events.select {|m| m.receiver == method.receiver and m.name == method.name }.empty?
        else
          events.push blk if events.select {|b| b == blk }.empty?
        end
      end

      # When `event` is triggered, do not call the given
      # block any more
      def off(event, method = nil, &blk)
        events = _events_for_key(event)
        if method
          events.delete_if { |m| m.receiver == method.receiver and m.name == method.name }
        else
          events.delete_if { |b| b == blk }
        end
        blk
      end

      # Trigger an event
      def trigger(event, *args)
        blks = _events_for_key(event).clone
        blks.map do |blk|
          blk.call(*args)
        end
      end

      private

      def __events__
        @__events__ ||= Hash.new
      end

      def _events_for_key(event)
        __events__[event] ||= Array.new
      end
    end
  end
end

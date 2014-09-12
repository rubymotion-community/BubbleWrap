module BubbleWrap
  module Reactor
    class ThreadAwareDeferrable < DefaultDeferrable
      include ::BubbleWrap::Reactor::Deferrable

      
      # need to store the the queue in callback / errback
      def callback(&blk)
        super(&blk)
        @block_queues ||= {}
        @block_queues[blk.object_id] = Dispatch::Queue.current

        puts @block_queues
      end

    end
  end
end


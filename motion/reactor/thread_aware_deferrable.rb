module BubbleWrap
  module Reactor
    class ThreadAwareDeferrable < DefaultDeferrable
      include ::BubbleWrap::Reactor::Deferrable

      
      # need to store the the queue in callback / errback
      def callback(&blk)
        return unless blk
        cache_block_queue(&blk)
        super(&blk)
      end

      def errback(&blk)
        return unless blk
        cache_block_queue(&blk)
        super(&blk)
      end

      def execute_block(&blk)
        return unless blk
        queue = @queue_cache.delete(blk.object_id)
        return unless queue
        queue.async do
          blk.call(*@deferred_args)
        end
      end

      def cache_block_queue(&blk)
        return unless blk
        @queue_cache ||= {}
        @queue_cache[blk.object_id] = Dispatch::Queue.current
      end
    end
  end
end


module BubbleWrap
  module Reactor
    # A GCD scheduled, linear queue.
    #
    # This class provides a simple “Queue” like abstraction on top of the 
    # GCD scheduler. 
    #
    # Useful as an API sugar for stateful protocols
    #
    #  q = BubbleWrap::Reactor::Queue.new
    #  q.push('one', 'two', 'three')
    #  3.times do
    #    q.pop{ |msg| puts(msg) }
    #  end
    class Queue

      # Create a new queue
      def initialize
        @items = []
      end

      # Is the queue empty?
      def empty?
        @items.empty?
      end

      # The size of the queue
      def size
        @items.size
      end

      # Push items onto the work queue. The items will not appear in the queue 
      # immediately, but will be scheduled for addition.
      def push(*items)
        ::BubbleWrap::Reactor.schedule do 
          @items.push(*items)
          @popq.shift.call @items.shift until @items.empty? || @popq.empty?
        end
      end

      # Pop items off the queue, running the block on the work queue. The pop 
      # will not happen immediately, but at some point in the future, either 
      # in the next tick, if the queue has data, or when the queue is populated.
      def pop(*args, &blk)
        cb = proc do
          blk.call(*args)
        end
        ::BubbleWrap::Reactor.schedule do
          if @items.empty?
            @popq << cb
          else
            cb.call @items.shift
          end
        end
        nil # Always returns nil
      end

    end
  end
end

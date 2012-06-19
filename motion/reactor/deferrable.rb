module BubbleWrap
  module Reactor
    # Provides a mixin for deferrable jobs.
    module Deferrable

      # def self.included(base)
      #   base.extend ::BubbleWrap::Reactor::Future
      # end

      # Specify a block to be executed if and when the Deferrable object 
      # receives a status of :succeeded. See set_deferred_status for more 
      # information.
      # Calling this method on a Deferrable object whose status is not yet 
      # known will cause the callback block to be stored on an internal 
      # list. If you call this method on a Deferrable whose status is 
      # :succeeded, the block will be executed immediately, receiving 
      # the parameters given to the prior set_deferred_status call.
      def callback(&blk)
        return unless blk
        @deferred_status ||= :unknown
        if @deferred_status == :succeeded
          blk.call(*@deferred_args)
        elsif @deferred_status != :failed
          @callbacks ||= []
          @callbacks.unshift blk
        end
      end

      # Cancels an outstanding timeout if any. Undoes the action of timeout.
      def cancel_timeout
        @deferred_timeout ||= nil
        if @deferred_timeout
          @deferred_timeout.cancel
          @deferred_timeout = nil
        end
      end

      # Specify a block to be executed if and when the Deferrable object 
      # receives a status of :failed. See set_deferred_status for more 
      # information.
      def errback(&blk)
        return unless blk
        @deferred_status ||= :unknown
        if @deferred_status == :failed
          blk.call(*@deferred_args)
        elsif @deferred_status != :succeeded
          @errbacks ||= []
          @errbacks.unshift blk 
        end
      end

      # Sugar for set_deferred_status(:failed, …)
      def fail(*args)
        set_deferred_status :failed, *args
      end
      alias set_deferred_failure fail

      # Sets the “disposition” (status) of the Deferrable object. See also 
      # the large set of sugarings for this method. Note that if you call 
      # this method without arguments, no arguments will be passed to the 
      # callback/errback. If the user has coded these with arguments, 
      # then the user code will throw an argument exception. Implementors 
      # of deferrable classes must document the arguments they will supply 
      # to user callbacks.
      # OBSERVE SOMETHING VERY SPECIAL here: you may call this method even 
      # on the INSIDE of a callback. This is very useful when a 
      # previously-registered callback wants to change the parameters that 
      # will be passed to subsequently-registered ones.
      # You may give either :succeeded or :failed as the status argument.
      # If you pass :succeeded, then all of the blocks passed to the object 
      # using the callback method (if any) will be executed BEFORE the 
      # set_deferred_status method returns. All of the blocks passed to the 
      # object using errback will be discarded.
      # If you pass :failed, then all of the blocks passed to the object 
      # using the errback method (if any) will be executed BEFORE the 
      # set_deferred_status method returns. All of the blocks passed to the 
      # object using # callback will be discarded.
      # If you pass any arguments to set_deferred_status in addition to the 
      # status argument, they will be passed as arguments to any callbacks 
      # or errbacks that are executed. It’s your responsibility to ensure 
      # that the argument lists specified in your callbacks and errbacks match 
      # the arguments given in calls to set_deferred_status, otherwise Ruby 
      # will raise an ArgumentError.
      def set_deferred_status(status, *args)
        cancel_timeout
        @errbacks ||= nil
        @callbacks ||= nil
        @deferred_status = status
        @deferred_args = args
        case @deferred_status
        when :succeeded
          if @callbacks
            while cb = @callbacks.pop
              cb.call(*@deferred_args)
            end
          end
          @errbacks.clear if @errbacks
        when :failed
          if @errbacks
            while eb = @errbacks.pop
              eb.call(*@deferred_args)
            end
          end
          @callbacks.clear if @callbacks
        end
      end

      # Sugar for set_deferred_status(:succeeded, …)
      def succeed(*args)
        set_deferred_status :succeeded, *args
      end
      alias set_deferred_success succeed

      # Setting a timeout on a Deferrable causes it to go into the failed 
      # state after the Timeout expires (passing no arguments to the object’s 
      # errbacks). Setting the status at any time prior to a call to the 
      # expiration of the timeout will cause the timer to be cancelled.
      def timeout(seconds)
        cancel_timeout
        me = self
        @deferred_timeout = Timer.new(seconds) {me.fail}
      end

    end
  end
end

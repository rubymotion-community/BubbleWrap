module BubbleWrap
  module Reactor
    module_function

    # Always returns true - for compatibility with EM
    def reactor_running?
      true
    end
    alias reactor_thread? reactor_running?

    # Call `callback` or the passed block in `interval` seconds.
    # Returns a timer signature that can be passed into
    # `cancel_timer`
    def add_timer(interval, callback=nil, &blk)
      @timers ||= {}
      timer = Timer.new(interval,callback,&blk)
      timer.on(:fired) do
        @timers.delete(timer.object_id)
      end
      timer.on(:cancelled) do
        @timers.delete(timer.object_id)
      end
      @timers[timer.object_id] = timer
      timer.object_id
    end

    # Cancel a timer by passing in either a Timer object or
    # a timer id (as returned by `add_timer` and
    # `add_periodic_timer`).
    def cancel_timer(timer)
      return timer.cancel if timer.respond_to?(:cancel)
      @timers ||= {}
      return @timers[timer].cancel if @timers[timer]
      false
    end

    # Call `callback` or the passed block every `interval` seconds.
    # Returns a timer signature that can be passed into
    # `cancel_timer`
    # Optionally supply a callback as a second argument instead of a block
    # (as per EventMachine API)
    # Optionally supply :common_modes => true in args to schedule the timer
    # for the runloop "common modes" (NSRunLoopCommonModes) instead of
    # the default runloop mode.
    def add_periodic_timer(interval, *args, &blk)
      @timers ||= {}
      timer = PeriodicTimer.new(interval,*args,&blk)
      timer.on(:cancelled) do
        @timers.delete(timer)
      end
      @timers[timer.object_id] = timer
      timer.object_id
    end

    # Defer is for integrating blocking operations into the reactor's control
    # flow.
    # Call defer with one or two blocks, the second block is optional.
    #     operation = proc do
    #       # perform a long running operation here
    #       "result"
    #     end
    #     callback = proc do |result|
    #       # do something with the result here, such as trigger a UI change
    #     end
    #     BubbleWrap::Reactor.defer(operation,callback)
    # The action of `defer` is to take the block specified in the first
    # parameter (the "operation") and schedule it for asynchronous execution
    # on a GCD concurrency queue. When the operation completes the result (if any)
    # is passed into the callback (if present).
    def defer(op=nil,cb=nil,&blk) 
      schedule do
        result = (op||blk).call
        schedule(result, &cb) if cb
      end
    end

    # A version of `defer` which schedules both the operator
    # and callback operations on the application's main thread.
    def defer_on_main(op=nil,cb=nil,&blk) 
      schedule_on_main do
        result = (op||blk).call
        schedule_on_main(result, &cb) if cb
      end
    end

    # Schedule a block for execution on the reactor queue.
    def schedule(*args, &blk)
      @queue ||= ::Dispatch::Queue.concurrent("#{NSBundle.mainBundle.bundleIdentifier}.reactor")

      cb = proc do
        blk.call(*args)
      end
      @queue.async &cb
      nil
    end

    # Schedule a block for execution on your application's main thread.
    # This is useful as UI updates need to be executed from the main
    # thread.
    def schedule_on_main(*args, &blk)
      cb = proc do
        blk.call(*args)
      end
      ::Dispatch::Queue.main.async &cb
    end
    
  end
end

::EM = ::BubbleWrap::Reactor unless defined?(::EM) # Yes I dare!

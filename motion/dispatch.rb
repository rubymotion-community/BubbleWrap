module BubbleWrap
  module Dispatch
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
      return timer.cancel if timer.respond_to(:cancel)
      @timers ||= {}
      return @timers[timer].cancel if @timers[timer]
      false
    end

    # Call `callback` or the passed block every `interval` seconds.
    # Returns a timer signature that can be passed into
    # `cancel_timer`
    def add_periodic_timer(interval, callback=nil, &blk)
      @timers ||= {}
      timer = PeriodicTimer.new(internval,callback,blk)
      timer.on(:cancelled) do
        @timers.delete(timer)
      end
      @timers[timer.object_id] = timer
      timer.object_id
    end

    def defer(op=nil,cb=nil,&blk) 
      schedule do
        result = (op||blk).call
        schedule(result, &cb) if cb
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

    # Schedule a block for execution on your applcation's main thread.
    # This is useful as UI updates need to be executed from the main
    # thread.
    def main(*args, &blk)
      cb = proc do
        blk.call(*args)
      end
      ::Dispatch::Queue.main.async &cb
    end
    
  end
end

::EM = ::BubbleWrap::Dispatch # Yes I dare!

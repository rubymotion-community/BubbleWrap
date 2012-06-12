module BubbleWrap
  module Dispatch
    module_function

    # Call `callback` or the passed block in `interval` seconds.
    def add_timer(interval, callback=nil, &blk)
      @timers ||= []
      timer = Timer.new(interval,callback,&blk)
      timer.on(:fired) do
        @timers.delete(timer)
      end
      @timers.unshift(timer)
      timer
    end

    # Call `callback` or the passed block every `interval` seconds.
    def add_periodic_timer(interval, callback=nil, &blk)
      @periodic_timers ||= []
      timer = PeriodicTimer.new(internval,callback,blk)
      timer.on(:cancelled) do
        @periodic_timers.delete(timer)
      end
      @periodic_timers.unshift(timer)
      timer
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

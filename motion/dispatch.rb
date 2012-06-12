module BubbleWrap
  module Dispatch
    module_function

    def add_timer(interval, callback=nil, &blk)
      @timers ||= []
      timer = Timer.new(interval,callback,&blk)
      timer.on(:fired) do
        @timers.delete(timer)
      end
      @timers.unshift(timer)
      timer
    end

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
    end
    
  end
end

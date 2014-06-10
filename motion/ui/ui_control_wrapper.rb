module BubbleWrap
  module UIControlWrapper
    def when(events, options = {}, &block)
      @callback ||= {}
      @callback[events] ||= []

      unless options[:append]
        @callback[events] = []
        removeTarget(nil, action: nil, forControlEvents: events)
      end

      @callback[events] << block
      block.weak! if BubbleWrap.use_weak_callbacks?
      addTarget(@callback[events].last, action:'call', forControlEvents: events)
    end
  end
end

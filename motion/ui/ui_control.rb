module UIControlWrap
  def when(events, options={}, &block)
    @callback ||= {}
    @callback[events] ||= []
    
    unless options[:append]
      @callback[events] = []
      removeTarget(nil, action: nil, forControlEvents: events)
    end

    @callback[events] << block
    addTarget(@callback[events].last, action:'call', forControlEvents: events)
  end
end

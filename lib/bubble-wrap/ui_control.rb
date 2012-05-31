module UIControlWrap
  def when(events, &block)
    @callback ||= {}
    @callback[events] = block
    addTarget(@callback[events], action:'call', forControlEvents: events)
  end
end

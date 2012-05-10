class NSNotificationCenter
  def observe(key, name, object=nil, &proc)
    @observers = {} unless @observers
    @observers[key] = proc
    self.addObserver(proc, selector:'call', name:name, object:object)
  end

  def unobserve(key)
    proc = @observers[key].delete
    self.removeObserver(proc)
  end
end
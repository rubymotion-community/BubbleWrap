class NSNotificationCenter
  def observers
    @observers ||= []
  end

  def observe(name, object=nil, &proc)
    observer = self.addObserverForName(name, object:object, queue:NSOperationQueue.mainQueue, usingBlock:proc)
    observers << observer
    observer
  end

  def unobserve(observer)
    return unless observers.include?(observer)
    removeObserver(observer)
    observers.delete(observer)
  end
  
  def post(name, object=nil, info=nil)
    self.postNotificationName(name, object: object, userInfo: info)
  end
end
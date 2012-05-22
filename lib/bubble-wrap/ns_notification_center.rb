class NSNotificationCenter
  attr_reader :observers

  def observe(observer, name, object=nil, &proc)
    @observers            ||= {}
    @observers[observer]  ||= []
    @observers[observer]  << proc
    self.addObserver(proc, selector:'call', name:name, object:object)
  end

  def unobserve(observer)
    return unless @observers[observer]
    @observers[observer].each do |proc|
      removeObserver(proc)
    end
    @observers.delete(observer)
  end
  
  def post(name, object=nil, info=nil)
    self.postNotificationName(name, object: object, userInfo:info)
  end
end
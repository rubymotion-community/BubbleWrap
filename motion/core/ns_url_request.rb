class NSURLRequest

  # Provides a to_s method so we can use inspect in instances and get
  # valuable information.
  def to_s
    "#<#{self.class}:#{self.object_id} - url: #{self.URL.description}, 
    headers: #{self.allHTTPHeaderFields.inspect}, 
    cache policy: #{self.cachePolicy}, Pipelining: #{self.HTTPShouldUsePipelining}, main doc url: #{mainDocumentURL},\
    timeout: #{self.timeoutInterval}, network service type: #{self.networkServiceType} >"
  end

end

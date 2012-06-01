class Time
  def self.iso8601(time)
    formatter = NSDateFormatter.alloc.init
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    formatter.dateFromString time
  end
end

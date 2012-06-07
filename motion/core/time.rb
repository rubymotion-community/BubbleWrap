class Time
  def self.memoized_date_formatter(dateFormat)
    Thread.current[:date_formatters] ||= {}
    Thread.current[:date_formatters][dateFormat] ||= 
      NSDateFormatter.alloc.init.tap do |formatter|
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.timeZone   = NSTimeZone.timeZoneWithAbbreviation "UTC"
      end
  end
  
  def self.iso8601(time)
    memoized_date_formatter("yyyy-MM-dd'T'HH:mm:ss'Z'").
      dateFromString(time)
  end
end

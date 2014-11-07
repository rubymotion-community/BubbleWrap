class Time

  def self.iso8601(time)
    if time.include?(".")
      # Fractional Seconds
      if time.include?('Z')
        iso8601_with_fractional_seconds(time)
      else
        iso8601_with_fractional_seconds_and_timesone(time)
      end
    else
      # Non Fractional Seconds
      if time.include?('Z')
        iso8601_zulu(time)
      else
        iso8601_with_timezone(time)
      end
    end
  end

  def self.iso8601_zulu(time)
    cached_date_formatter("yyyy-MM-dd'T'HH:mm:ss'Z'").
      dateFromString(time)
  end

  def self.iso8601_with_timezone(time)
    cached_date_formatter("yyyy-MM-dd'T'HH:mm:ssZZZZZ").
      dateFromString(time)
  end

  def self.iso8601_with_fractional_seconds(time)
    cached_date_formatter("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").
      dateFromString(time)
  end

  def self.iso8601_with_fractional_seconds_and_timesone(time)
    cached_date_formatter("yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ").
      dateFromString(time)
  end

  private

  def self.cached_date_formatter(dateFormat)
    Thread.current[:date_formatters] ||= {}
    Thread.current[:date_formatters][dateFormat] ||=
      NSDateFormatter.alloc.init.tap do |formatter|
        formatter.dateFormat = dateFormat
        formatter.timeZone   = NSTimeZone.timeZoneWithAbbreviation "UTC"
      end
  end

end

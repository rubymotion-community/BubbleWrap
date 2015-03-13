describe "Time" do

  describe "Caching the date formatter" do

    it "should reuse the created formatter" do
      100.times do
        Time.iso8601("2011-04-11T13:22:21Z")
      end

      Thread.current[:date_formatters].count.should.equal 1
      Thread.current[:date_formatters]["yyyy-MM-dd'T'HH:mm:ss'Z'"].should.not.equal nil
    end

  end

  describe "auto-parsing of different iso8601 formats" do
    before do
      @time = '1981-12-23T19:41:32-400'
      @time_zulu = '1981-12-23T19:41:32Z'
      @time_fractional_seconds = '1981-12-23T19:41:32.324-400'
      @time_fractional_seconds_zulu = '1981-12-23T19:41:32.324Z'
    end

    it "should parse a normal iso8601 time" do
      Time.iso8601(@time).instance_of?(Time).should == true
    end

    it "should parse an iso8601 time with zulu timezone" do
      Time.iso8601(@time_zulu).instance_of?(Time).should == true
    end

    it "should parse an iso8601 time with fractional time" do
      Time.iso8601(@time_fractional_seconds).instance_of?(Time).should == true
    end

    it "should parse an iso8601 time with fractional time and zulu timezone" do
      Time.iso8601(@time_fractional_seconds_zulu).instance_of?(Time).should == true
    end
  end

  describe "parsing an iso8601 formatted time to a Time object" do
    before do
      @time = Time.iso8601("2012-#{Time.now.month}-#{Time.now.day}T19:41:32Z")
      @time_with_timezone = Time.iso8601_with_timezone("1987-08-10T06:00:00+02:00")
      @time_with_fractional_seconds = Time.iso8601_with_fractional_seconds("2012-#{Time.now.month}-#{Time.now.day}T19:41:32.123Z")
      @time_with_fractional_seconds_and_timezone = Time.iso8601_with_fractional_seconds_and_timesone("2012-#{Time.now.month}-#{Time.now.day}T19:41:32.123+02:00")
    end

    it "should be a time" do
      @time.instance_of?(Time).should == true
      @time_with_timezone.instance_of?(Time).should == true
      @time_with_fractional_seconds.instance_of?(Time).should == true
      @time_with_fractional_seconds_and_timezone.instance_of?(Time).should == true
    end

    # Crashes Buggy RubyMotion 1.18
    it "should be converted to the local timezone automatically" do
      local_zone = Time.now.zone
      @time.zone.should == local_zone
      @time_with_timezone.zone == local_zone
      @time_with_fractional_seconds.zone.should == local_zone
      @time_with_fractional_seconds_and_timezone.zone.should == local_zone
    end

    it "should have a valid year" do
      @time.utc.year.should == 2012
      @time_with_timezone.utc.year.should == 1987
      @time_with_fractional_seconds.utc.year.should == 2012
      @time_with_fractional_seconds_and_timezone.utc.year.should == 2012
    end

    it "should have a valid month" do
      @time.utc.month.should == Time.now.month
      @time_with_timezone.utc.month.should == 8
      @time_with_fractional_seconds.utc.month.should == Time.now.month
      @time_with_fractional_seconds_and_timezone.utc.month.should == Time.now.month
    end

    it "should have a valid day" do
      @time.utc.day.should == Time.now.day
      @time_with_timezone.utc.day.should == 10
      @time_with_fractional_seconds.utc.day.should == Time.now.day
      @time_with_fractional_seconds_and_timezone.utc.day.should == Time.now.day
    end

    it "should have a valid hour" do
      @time.utc.hour.should == 19
      @time_with_timezone.utc.hour.should == 4
      @time_with_fractional_seconds.utc.hour.should == 19
      @time_with_fractional_seconds_and_timezone.utc.hour.should == 17
    end

    it "should have a valid minute" do
      @time.utc.min.should == 41
      @time_with_timezone.utc.min.should == 0
      @time_with_fractional_seconds.utc.min.should == 41
      @time_with_fractional_seconds_and_timezone.utc.min.should == 41
    end

    it "should have a valid second" do
      @time.utc.sec.should == 32
      @time_with_timezone.utc.sec.should == 0
      @time_with_fractional_seconds.utc.sec.should == 32
      @time_with_fractional_seconds_and_timezone.utc.sec.should == 32
    end
  end

end

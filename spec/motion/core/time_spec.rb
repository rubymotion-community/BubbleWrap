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


  describe "parsing an iso8601 formatted time to a Time object" do
    before do
      @time = Time.iso8601("2012-05-31T19:41:33Z")
      @time_with_timezone = Time.iso8601_with_timezone("1987-08-10T06:00:00+02:00")
    end

    it "should be a time" do
      @time.instance_of?(Time).should == true
      @time_with_timezone.instance_of?(Time).should == true
    end

    # Crashes Buggy RubyMotion 1.18
    it "should be converted to the local timezone automatically" do
      local_zone = Time.now.zone
      @time.zone.should == local_zone
      @time_with_timezone.zone == local_zone
    end

    it "should have a valid year" do
      @time.utc.year.should == 2012
      @time_with_timezone.utc.year.should == 1987
    end

    it "should have a valid month" do
      @time.utc.month.should == 5
      @time_with_timezone.utc.month.should == 8
    end

    it "should have a valid day" do
      @time.utc.day.should == 31
      @time_with_timezone.utc.day.should == 10
    end

    it "should have a valid hour" do
      @time.utc.hour.should == 19
      @time_with_timezone.utc.hour.should == 4
    end

    it "should have a valid minute" do
      @time.utc.min.should == 41
      @time_with_timezone.utc.min.should == 0
    end

    it "should have a valid second" do
      @time.utc.sec.should == 33
      @time_with_timezone.utc.sec.should == 0
    end
  end

end

describe "Time" do

  describe "parsing an iso8601 formatted time to a Time object" do
    before do
      @time = Time.iso8601("2012-05-31T19:41:33Z")
    end

    it "should be a time" do
      @time.instance_of?(Time).should == true
    end

    it "should be converted to the local timezone automatically" do
      @time.zone.should == Time.now.zone
    end

    it "should have a valid year" do
      @time.utc.year.should == 2012
    end

    it "should have a valid month" do
      @time.utc.month.should == 5
    end

    it "should have a valid day" do
      @time.utc.day.should == 31
    end

    it "should have a valid hour" do
      @time.utc.hour.should == 19
    end

    it "should have a valid minute" do
      @time.utc.min.should == 41
    end

    it "should have a valid second" do
      @time.utc.sec.should == 33
    end
  end

end

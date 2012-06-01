describe "Time" do

  describe "parsing an iso8601 formatted time to a Time object" do
    before do
      @time = Time.iso8601("2012-05-31T19:41:33Z")
    end

    it "should have a valid year" do
      @time.year.should == 2012
    end

    it "should have a valid month" do
      @time.month.should == 5
    end

    it "should have a valid day" do
      @time.day.should == 31
    end

    it "should have a valid hour" do
      @time.hour.should == 19
    end

    it "should have a valid minute" do
      @time.min.should == 41
    end

    it "should have a valid second" do
      @time.sec.should == 33
    end
  end

end

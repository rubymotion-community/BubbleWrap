describe "Time" do

  it "should parse an iso8601 formatted time to a Time object" do
    time = Time.iso8601("2012-05-31T19:41:33Z")
    time.year.should  == 2012
    time.month.should == 5
    time.day.should   == 31
    time.hour.should  == 19
    time.min.should   == 41
    time.sec.should   == 33
  end

end

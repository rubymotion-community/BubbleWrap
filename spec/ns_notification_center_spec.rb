describe "NSNotificationCenter" do
  SampleNotification = "SampleNotification"

  after do
    @observer = Object.new
  end
  
  after do
    BW.notification_center.unobserve(@observer)
  end

  it "return notification center" do
    BW.notification_center.should.not.be.nil
  end

  it "add observer" do
    notified = false
    BW.notification_center.observe(@observer, SampleNotification) do |note|
      notified = true
      note.class.should == NSNotification
      note.object.class.should == Time
      note.userInfo.should.not.be.nil
      note.userInfo[:status].should == "ok"
    end

    lambda { 
      BW.notification_center.post SampleNotification, Time.now, {:status => "ok"}
    }.should.change { notified }
  end

  it "remove observer" do
    lambda { 
      BW.notification_center.observe(@observer, SampleNotification) {}
      BW.notification_center.unobserve(@observer)
    }.should.not.change { BW.notification_center.observers.keys.size }
  end
end

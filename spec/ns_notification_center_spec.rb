describe "NSNotificationCenter" do
  SampleNotification = "SampleNotification"
  after do
    @observer = Object.new
  end
  
  after do
    notification_center.unobserve(@observer)
  end

  it "return notification center" do
    notification_center.should.not.be.nil
  end

  it "add observer" do
    notified = false
    notification_center.observe(@observer, SampleNotification) do |note|
      notified = true
      note.class.should == NSNotification
      note.object.class.should == Time
      note.userInfo.should.not.be.nil
      note.userInfo[:status].should == "ok"
    end

    lambda { 
      notification_center.post SampleNotification, Time.now, {:status => "ok"}
    }.should.change { notified }
  end

  it "remove observer" do
    lambda { 
      notification_center.observe(@observer, SampleNotification) {}
      notification_center.unobserve(@observer)
    }.should.not.change { notification_center.observers.keys.size }
  end
end
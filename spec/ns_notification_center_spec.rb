describe "NSNotificationCenter" do
  SampleNotification = "SampleNotification"

  after do
    @observer = nil
  end
  
  after do
    BW::App.notification_center.unobserve(@observer) if @observer
  end

  it "return notification center" do
    BW::App.notification_center.should.not.be.nil
  end

  it "add observer" do
    notified = false
    @observer = BW::App.notification_center.observe(SampleNotification) do |note|
      notified = true
      note.should.is_a NSNotification
      note.object.class.should == Time
      note.userInfo.should.not.be.nil
      note.userInfo[:status].should == "ok"
    end

    lambda { 
      BW::App.notification_center.post SampleNotification, Time.now, {:status => "ok"}
    }.should.change { notified }
  end

  it "remove observer" do
    lambda { 
      @observer = BW::App.notification_center.observe(SampleNotification) {}
      BW::App.notification_center.unobserve(@observer)
    }.should.not.change { BW::App.notification_center.observers.size }
  end
end

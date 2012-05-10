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
    notification_center.observe(@observer, SampleNotification) do
      notified = true
    end

    lambda { 
      notification_center.post SampleNotification
    }.should.change { notified }
  end

  it "remove observer" do
    lambda { 
      notification_center.observe(@observer, SampleNotification) {}
      notification_center.unobserve(@observer)
    }.should.not.change { notification_center.observers.keys.size }
  end
end
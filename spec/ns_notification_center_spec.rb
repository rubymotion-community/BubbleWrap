describe "NSNotificationCenter" do
  SampleNotification = "SampleNotification"
  after do
    @observer = Object.new
  end
  
  after do
    notification_center.unobserve(@observe)
  end

  it "return notification center" do
    notification_center.should.not.be.nil
  end

  it "add observer" do
    notified = false
    notification_center.observe(@observe, SampleNotification) do
      notified = true
    end

    lambda { 
      notification_center.post SampleNotification
    }.should.change { notified }
  end

  it "remove observer" do
    notification_center.observe(@observe, SampleNotification) do
      notified = true
    end
    
    lambda { 
      notification_center.unobserve(@observe)
    }.should.change { notification_center.observers.keys.size }
  end
end

describe BW::Message::Result do
  
  before do
    @subject = BW::Message::Result.new(MessageComposeResultCancelled)
  end
  
  it "should set sent? when sent" do
    @subject.result = MessageComposeResultSent
    @subject.should.be.sent
  end
  
  it "should not set sent? when not sent" do
    @subject.result = MessageComposeResultFailed
    @subject.should.not.be.sent
  end
  
  it "should set canceled? when canceled" do
    @subject.result = MessageComposeResultCancelled
    @subject.should.be.canceled
  end

  it "should not set canceled? when not canceled" do
    @subject.result = MessageComposeResultFailed
    @subject.should.not.be.canceled
  end
  
  
  it "should set failed? when failed" do
    @subject.result = MessageComposeResultFailed
    @subject.should.be.failed
  end

  it "should not set failed? when not failed" do
    @subject.result = MessageComposeResultSent
    @subject.should.not.be.failed
  end

end

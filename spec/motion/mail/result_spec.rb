describe BW::Mail::Result do

  before do
    @subject = BW::Mail::Result.new(MFMailComposeResultCancelled, nil)
  end

  it "should set sent? when sent" do
    @subject.result = MFMailComposeResultSent
    @subject.should.be.sent
  end

  it "should not set sent? when not sent" do
    @subject.result = MFMailComposeResultCancelled
    @subject.should.not.be.sent
  end

  it "should set canceled? when canceled" do
    @subject.result = MFMailComposeResultCancelled
    @subject.should.be.canceled
  end

  it "should not set canceled? when not canceled" do
    @subject.result = MFMailComposeResultSent
    @subject.should.not.be.canceled
  end

  it "should set saved? when saved" do
    @subject.result = MFMailComposeResultSaved
    @subject.should.be.saved
  end

  it "should not set saved? when not saved" do
    @subject.result = MFMailComposeResultFailed
    @subject.should.not.be.saved
  end

  it "should set failed? when failed" do
    @subject.result = MFMailComposeResultFailed
    @subject.should.be.failed
  end

  it "should not set failed? when not failed" do
    @subject.result = MFMailComposeResultSent
    @subject.should.not.be.failed
  end

  it "should set failed? when error" do
    @subject.result = MFMailComposeResultCancelled
    @subject.error = :errored
    @subject.should.be.failed
  end

end

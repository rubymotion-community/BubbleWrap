describe UIView do

  before do
    @view = App.delegate.window.rootViewController.view
    @orig = @view.isUserInteractionEnabled
    @view.setUserInteractionEnabled false
  end

  after do
    @view.setUserInteractionEnabled @orig
  end

  testMethod = proc do |method|
    it "returns a gesture recognizer" do
      recognizer = @view.send(method, false, &:nil)
      recognizer.is_a?(UIGestureRecognizer).should == true
    end

    it 'enables interaction when called' do
      @view.send(method, &:nil)
      @view.isUserInteractionEnabled.should == true
    end

    it "doesn't enable interaction if asked not to" do
      @view.send(method, false, &:nil)
      @view.isUserInteractionEnabled.should == false
    end

    # it 'responds to interaction'
  end

  describe '#whenTapped' do
    testMethod.call :whenTapped
  end

  describe '#whenPinched' do
    testMethod.call :whenPinched
  end

  describe '#whenRotated' do
    testMethod.call :whenRotated
  end
  
  describe '#whenSwiped' do
    testMethod.call :whenSwiped
  end

  describe '#whenPanned' do
    testMethod.call :whenPanned
  end

  describe '#whenPressed' do
    testMethod.call :whenPressed
  end

end

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

  describe '#when_tapped' do
    testMethod.call :when_tapped
    testMethod.call :whenTapped
  end

  describe '#when_pinched' do
    testMethod.call :when_pinched
    testMethod.call :whenPinched
  end

  describe '#when_rotated' do
    testMethod.call :when_rotated
    testMethod.call :whenRotated
  end
  
  describe '#when_swiped' do
    testMethod.call :when_swiped
    testMethod.call :whenSwiped
  end

  describe '#when_panned' do
    testMethod.call :when_panned
    testMethod.call :whenPanned
  end

  describe '#when_pressed' do
    testMethod.call :when_pressed
    testMethod.call :whenPressed
  end

end

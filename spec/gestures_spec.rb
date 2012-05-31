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
    it 'enables interaction when called' do
      @view.whenTapped &:nil?
      @view.isUserInteractionEnabled.should == true
    end

    # it 'responds to interaction'
  end

  describe '#whenTapped' do
    testMethod.call :whenTapped
  end

end

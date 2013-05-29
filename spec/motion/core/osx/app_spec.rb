describe BubbleWrap::App do
  describe "OS X" do
    describe '.delegate' do
      it 'returns a TestSuiteDelegate' do
        App.delegate.should == NSApplication.sharedApplication.delegate
      end
    end

    describe '.shared' do
      it 'returns UIApplication.sharedApplication' do
        App.shared.should == NSApplication.sharedApplication
      end
    end
  end
end
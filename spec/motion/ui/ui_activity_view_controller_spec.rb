describe BubbleWrap::UIActivityViewController do
  before do
    @controller = UIViewController.alloc.init
    @controller.instance_eval do
      def presentViewController(*args)
        true
      end
    end
  end

  it 'Creates an instance of UIActivityViewController' do
    activity = BW::UIActivityViewController.new()
    activity.kind_of?(UIActivityViewController).should == true
  end

  it 'Sets a completion block' do
  end

  it 'Sets a single excluded activity' do
  end

  it 'Sets multiple excluded activities' do
  end

  it 'Sets transition styles for showing the controller' do
  end

end

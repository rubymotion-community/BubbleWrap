describe BubbleWrap::UIActivityViewController do
  before do
    @controller = UIViewController.alloc.init
    @controller.instance_eval do
      def presentViewController(*args)
        true
      end
    end

    @options = options = {
      item:"BubbleWrap!!!",
      animated:false
    }
  end

  after do
    presenting_controller ||= App.window.rootViewController.presentedViewController
    presenting_controller ||= App.window.rootViewController
    presenting_controller.dismissViewControllerAnimated(false, completion:nil)
  end

  it 'Creates an instance of UIActivityViewController' do
    activity = BW::UIActivityViewController.new(@options)

    activity.kind_of?(UIActivityViewController).should == true
    activity.excludedActivityTypes.should == nil
    activity.activityItems.is_a?(Array).should == true
    activity.activityItems.count.should == 1
  end

  it 'Sets a completion block' do
    activity = BW::UIActivityViewController.new(@options) do |activity_type, completed|
      test = 2
    end
    activity.completionHandler.should.not == nil
  end

  it 'Sets multiple items' do
    options = @options.tap { |o| o.delete(:item) }.merge(items: ["Hello", "BubbleWrap!"])

    activity = BW::UIActivityViewController.new(options)
    activity.activityItems.is_a?(Array).should == true
    activity.activityItems.count.should == 2
  end

  it 'Sets a single excluded activity' do
    activity = BW::UIActivityViewController.new(@options.merge(excluded: :print))
    activity.excludedActivityTypes.is_a?(Array).should == true
    activity.excludedActivityTypes.count.should == 1
  end

  it 'Sets multiple excluded activities' do
    activity = BW::UIActivityViewController.new(@options.merge(excluded: [:print, :add_to_reading_list]))
    activity.excludedActivityTypes.is_a?(Array).should == true
    activity.excludedActivityTypes.count.should == 2
  end

end

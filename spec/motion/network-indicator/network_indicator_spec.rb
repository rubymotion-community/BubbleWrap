describe BW::NetworkIndicator do

  after do
    BW::NetworkIndicator.instance_variable_set(:@counter, 0)
    UIApplication.sharedApplication.networkActivityIndicatorVisible = false
  end

  it 'should show the indicator' do
    BW::NetworkIndicator.show
    UIApplication.sharedApplication.networkActivityIndicatorVisible?.should == true
  end

  it 'should hide the indicator' do
    BW::NetworkIndicator.show
    BW::NetworkIndicator.hide
    UIApplication.sharedApplication.networkActivityIndicatorVisible?.should == false
  end

  it 'should keep track of how many times `show` was called' do
    BW::NetworkIndicator.show
    BW::NetworkIndicator.show
    UIApplication.sharedApplication.networkActivityIndicatorVisible?.should == true
    BW::NetworkIndicator.hide
    UIApplication.sharedApplication.networkActivityIndicatorVisible?.should == true
    BW::NetworkIndicator.hide
    UIApplication.sharedApplication.networkActivityIndicatorVisible?.should == false
  end

  it 'should allow `hide` to be called too many times' do
    BW::NetworkIndicator.show
    BW::NetworkIndicator.show
    BW::NetworkIndicator.hide
    BW::NetworkIndicator.hide
    UIApplication.sharedApplication.networkActivityIndicatorVisible?.should == false

    BW::NetworkIndicator.hide
    BW::NetworkIndicator.hide
    UIApplication.sharedApplication.networkActivityIndicatorVisible?.should == false

    BW::NetworkIndicator.show
    UIApplication.sharedApplication.networkActivityIndicatorVisible?.should == true
  end

  it 'should reset the counter when `reset!` is called' do
    BW::NetworkIndicator.show
    BW::NetworkIndicator.show
    BW::NetworkIndicator.reset!
    UIApplication.sharedApplication.networkActivityIndicatorVisible?.should == false
  end

  it 'should have `visible?` method' do
    BW::NetworkIndicator.show
    BW::NetworkIndicator.visible?.should == true
    BW::NetworkIndicator.hide
    BW::NetworkIndicator.visible?.should == false
  end

end

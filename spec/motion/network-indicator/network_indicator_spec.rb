describe BW::NetworkIndicator do

  after do
    BW::NetworkIndicator.instance_variable_set(:@counter, 0)
    UIApplication.sharedApplication.networkActivityIndicatorVisible = false
  end

  it 'should show the indicator immediately' do
    BW::NetworkIndicator.show
    UIApplication.sharedApplication.networkActivityIndicatorVisible?.should == true
  end

  it 'should show the indicator from any thread' do
    Dispatch::Queue.concurrent.async do
      BW::NetworkIndicator.show
    end
    wait BW::NetworkIndicator::DELAY do
      UIApplication.sharedApplication.networkActivityIndicatorVisible?.should == true
    end
  end

  it 'should hide the indicator' do
    BW::NetworkIndicator.show
    BW::NetworkIndicator.hide
    wait BW::NetworkIndicator::DELAY do
      UIApplication.sharedApplication.networkActivityIndicatorVisible?.should == false
    end
  end

  it 'should hide the indicator after a delay' do
    BW::NetworkIndicator.show
    BW::NetworkIndicator.hide
    UIApplication.sharedApplication.networkActivityIndicatorVisible?.should == true
    wait BW::NetworkIndicator::DELAY do
      UIApplication.sharedApplication.networkActivityIndicatorVisible?.should == false
    end
  end

  it 'should not hide the indicator if show/hide/show is called quickly' do
    BW::NetworkIndicator.show
    BW::NetworkIndicator.hide
    UIApplication.sharedApplication.networkActivityIndicatorVisible?.should == true
    wait BW::NetworkIndicator::DELAY/2 do
      UIApplication.sharedApplication.networkActivityIndicatorVisible?.should == true
      BW::NetworkIndicator.show
      wait BW::NetworkIndicator::DELAY do
        UIApplication.sharedApplication.networkActivityIndicatorVisible?.should == true
      end
    end
  end

  it 'should keep track of how many times `show` was called' do
    BW::NetworkIndicator.show
    BW::NetworkIndicator.show
    UIApplication.sharedApplication.networkActivityIndicatorVisible?.should == true
    BW::NetworkIndicator.hide
    wait BW::NetworkIndicator::DELAY do
      UIApplication.sharedApplication.networkActivityIndicatorVisible?.should == true
      BW::NetworkIndicator.hide
      wait BW::NetworkIndicator::DELAY do
        UIApplication.sharedApplication.networkActivityIndicatorVisible?.should == false
      end
    end
  end

  it 'should allow `hide` to be called too many times' do
    BW::NetworkIndicator.show
    BW::NetworkIndicator.show
    BW::NetworkIndicator.hide
    BW::NetworkIndicator.hide
    wait BW::NetworkIndicator::DELAY do
      UIApplication.sharedApplication.networkActivityIndicatorVisible?.should == false

      BW::NetworkIndicator.hide
      BW::NetworkIndicator.hide
      wait BW::NetworkIndicator::DELAY do
        UIApplication.sharedApplication.networkActivityIndicatorVisible?.should == false

        BW::NetworkIndicator.show
        UIApplication.sharedApplication.networkActivityIndicatorVisible?.should == true
      end
    end
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
    wait BW::NetworkIndicator::DELAY do
      BW::NetworkIndicator.visible?.should == false
    end
  end

end

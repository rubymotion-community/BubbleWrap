describe "UIControlWrap" do
  describe 'UIButton' do
    before do
      @button = UIButton.buttonWithType(UIButtonTypeRoundedRect) 
      @touched = []
      @button.when(UIControlEventTouchUpInside) do
        @touched << 'for the very first time'
      end
    end

    it "supports the 'when' event handler for UIButton" do
      @button.sendActionsForControlEvents(UIControlEventTouchUpInside)
      @touched.should == ['for the very first time']
    end

    it "replaces the target for a given control event by default" do
      @button.when(UIControlEventTouchUpInside) do
        @touched << 'touched'
      end
      @button.sendActionsForControlEvents(UIControlEventTouchUpInside)
      @touched.should == ['touched']
    end

    it "allows multiple targets for a given control event if specified" do
      @button.when(UIControlEventTouchUpInside, append: true) do
        @touched << 'touched'
      end
      @button.sendActionsForControlEvents(UIControlEventTouchUpInside)
      @touched.should == ['for the very first time', 'touched']
    end
  end

  it "supports the 'when' event handler for UISlider" do
    button = UISlider.alloc.init
    changed = nil
    button.when(UIControlEventValueChanged) do
      changed = 1
    end
    button.sendActionsForControlEvents(UIControlEventValueChanged)
    changed.should == 1
  end
end

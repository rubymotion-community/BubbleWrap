describe "UIControlWrap" do

  it "should support the 'when' event handler" do
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    touched = nil
    button.when(UIControlEventTouchUpInside) do
      touched = 'for the very first time'
    end
    button.sendActionsForControlEvents(UIControlEventTouchUpInside)
    touched.should == 'for the very first time'
  end

  it "should support the 'when' event handler for UISlider" do
    button = UISlider.alloc.init
    changed = nil
    button.when(UIControlEventValueChanged) do
      changed = 1
    end
    button.sendActionsForControlEvents(UIControlEventValueChanged)
    changed.should == 1
  end
end

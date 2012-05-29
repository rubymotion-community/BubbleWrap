describe "UIButton" do

  it "should support the 'when' event handler" do
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    touched = nil
    button.when(UIControlEventTouchUpInside) do
      touched = 'for the very first time'
    end
    button.sendActionsForControlEvents(UIControlEventTouchUpInside)
    touched.should == 'for the very first time'
  end
end

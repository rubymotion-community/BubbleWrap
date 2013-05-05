describe BW::UIControlWrapper do
  describe "#when" do
    before do
      @subject = UIControl.alloc.init
      @touched = []

      @subject.when(UIControlEventTouchUpInside) do
        @touched << 'for the very first time'
      end
    end

    it "supports the 'when' event handler" do
      @subject.sendActionsForControlEvents(UIControlEventTouchUpInside)
      @touched.should.equal ['for the very first time']
    end

    it "replaces the target for a given control event by default" do
      @subject.when(UIControlEventTouchUpInside) do
        @touched << 'touched'
      end

      @subject.sendActionsForControlEvents(UIControlEventTouchUpInside)
      @touched.should.equal ['touched']
    end

    it "allows multiple targets for a given control event if specified" do
      @subject.when(UIControlEventTouchUpInside, append: true) do
        @touched << 'touched'
      end

      @subject.sendActionsForControlEvents(UIControlEventTouchUpInside)
      @touched.should.equal ['for the very first time', 'touched']
    end
  end
end

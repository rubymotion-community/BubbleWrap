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

    it "allows bitwise operators" do
      @subject.when(UIControlEventTouchUpInside | UIControlEventTouchUpOutside) do
        @touched << 'touched'
      end

      @subject.sendActionsForControlEvents(UIControlEventTouchUpInside)
      @touched.should.equal ['touched']

      @touched = []
      @touched.should.equal []

      @subject.sendActionsForControlEvents(UIControlEventTouchUpOutside)
      @touched.should.equal ['touched']
    end

    it "BubbleWrap.use_weak_callbacks=true removes cyclic references" do
      class ControlSuperView < UIView
        def initWithFrame(frame)
          super
          subject = UIControl.alloc.init
          subject.when(UIControlEventTouchUpInside) do
            #Can be empty, but we need a block/proc here to potentially create a retain cycle
          end
          addSubview(subject)
          self
        end

        def dealloc
          App.notification_center.post('ControlSuperView dealloc', nil, {'tag'=>tag})
          super
        end
      end

      observer = App.notification_center.observe('ControlSuperView dealloc') do |obj|
        if obj.userInfo['tag'] == 1
          @weak_deallocated = true
        elsif obj.userInfo['tag'] == 2
          @strong_deallocated = true
        end
      end
      autorelease_pool {
        BubbleWrap.use_weak_callbacks = true
        v1 = ControlSuperView.new
        v1.tag = 1
        BubbleWrap.use_weak_callbacks = false
        v2 = ControlSuperView.new
        v2.tag = 2
      }
      App.notification_center.unobserve(observer)
      @weak_deallocated.should.equal true
      @strong_deallocated.should.equal nil
    end

    it "allows multiple targets for a given control event if specified" do
      @subject.when(UIControlEventTouchUpInside, append: true) do
        @touched << 'touched'
      end

      @subject.sendActionsForControlEvents(UIControlEventTouchUpInside)
      @touched.should.equal ['for the very first time', 'touched']
    end

    it "allows symbols for actions" do
      @subject.when(:touch_up_inside) do
        @touched << 'touched'
      end

      @subject.sendActionsForControlEvents(UIControlEventTouchUpInside)
      @touched.should.equal ['touched']
    end
  end

  describe "#off" do
    before do
      @subject = UIControl.alloc.init
      @touched = []

      @subject.when(UIControlEventTouchUpInside) do
        @touched << 'for the very first time'
      end
    end

    it "should not invoke the block" do
      @subject.off(UIControlEventTouchUpInside)
      @subject.sendActionsForControlEvents(UIControlEventTouchUpInside)
      @touched.should.be.empty
    end

    it "should empty the ivar" do
      callback = @subject.instance_variable_get("@callback")
      callback[UIControlEventTouchUpInside].should.not.be.nil
      @subject.off(UIControlEventTouchUpInside)
      callback[UIControlEventTouchUpInside].should.be.nil
    end
  end
end

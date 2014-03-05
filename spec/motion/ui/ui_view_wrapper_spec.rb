describe BW::UIViewWrapper do
  describe "gestures" do
    before do
      @view = App.delegate.window.rootViewController.view
      @orig = @view.isUserInteractionEnabled
      @view.setUserInteractionEnabled false
    end

    after do
      @view.setUserInteractionEnabled @orig
    end

    testMethod = proc do |method|
      it "returns a gesture recognizer" do
        recognizer = @view.send(method, false, &:nil)
        recognizer.is_a?(UIGestureRecognizer).should == true
      end

      it 'enables interaction when called' do
        @view.send(method, &:nil)
        @view.isUserInteractionEnabled.should == true
      end

      it "doesn't enable interaction if asked not to" do
        @view.send(method, false, &:nil)
        @view.isUserInteractionEnabled.should == false
      end

      # it 'responds to interaction'
    end

    describe '#when_tapped' do
      testMethod.call :when_tapped
      testMethod.call :whenTapped
    end

    describe '#when_pinched' do
      testMethod.call :when_pinched
      testMethod.call :whenPinched
    end

    describe '#when_rotated' do
      testMethod.call :when_rotated
      testMethod.call :whenRotated
    end

    describe '#when_swiped' do
      testMethod.call :when_swiped
      testMethod.call :whenSwiped
    end

    describe '#when_panned' do
      testMethod.call :when_panned
      testMethod.call :whenPanned
    end

    describe '#when_screen_edge_panned' do
      testMethod.call :when_screen_edge_panned
    end

    describe '#when_pressed' do
      testMethod.call :when_pressed
      testMethod.call :whenPressed
    end

    it "BubbleWrap.use_weak_callbacks=true removes cyclic references" do
      class ViewSuperView < UIView
        def initWithFrame(frame)
          super
          subject = UIView.alloc.init
          subject.when_tapped do
            #Can be empty, but we need a block/proc here to potentially create a retain cycle
          end
          addSubview(subject)
          self
        end

        def dealloc
          App.notification_center.post('ViewSuperView dealloc', nil, {'tag'=>tag})
          super
        end
      end

      observer = App.notification_center.observe('ViewSuperView dealloc') do |obj|
        if obj.userInfo['tag'] == 1
          @weak_deallocated = true
        elsif obj.userInfo['tag'] == 2
          @strong_deallocated = true
        end
      end
      autorelease_pool {
        BubbleWrap.use_weak_callbacks = true
        v1 = ViewSuperView.new
        v1.tag = 1
        BubbleWrap.use_weak_callbacks = false
        v2 = ViewSuperView.new
        v2.tag = 2
      }
      App.notification_center.unobserve(observer)
      @weak_deallocated.should.equal true
      @strong_deallocated.should.equal nil
    end
  end
end

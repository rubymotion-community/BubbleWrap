describe BubbleWrap::Reactor::Eventable do
  before do
    @subject = Class.new do
      include BubbleWrap::Reactor::Eventable
    end.new
    @proxy = Class.new do
      attr_accessor :proof
    end.new
  end

  describe '.on' do
    it 'registers events passing a block' do
      proof = proc {  }
      @subject.on(:foo, &proof)
      events = @subject.instance_variable_get(:@__events__)
      events[:foo].member?(proof).should == true
    end

    it 'registers events passing a Method object' do
      def bar; end
      proof = method(:bar)
      @subject.on(:foo, proof)
      events = @subject.instance_variable_get(:@__events__)
      events[:foo].member?(proof).should == true
    end

    it 'returns the array of blocks for the event' do
      proof = proc {  }
      @subject.on(:foo, &proof).should == [proof]
    end
  end

  describe '.off' do
    it 'unregisters proc events' do
      proof = proc { }
      @subject.on(:foo, &proof)
      events = @subject.instance_variable_get(:@__events__)
      @subject.off(:foo, &proof)
      events[:foo].member?(proof).should == false
    end

    it 'unregisters method events' do
      def bar; end
      proof = method(:bar)
      @subject.on(:foo, proof)
      events = @subject.instance_variable_get(:@__events__)
      @subject.off(:foo, proof)
      events[:foo].member?(proof).should == false
    end

    it 'unregisters method events after kvo' do
      observing_object = Class.new do
        include BubbleWrap::KVO
      end.new

      @subject.on(:foo, @subject.method(:description))
      block = lambda { |old_value, new_value| }
      observing_object.observe(@subject, :cool_variable, &block)
      @subject.off(:foo, @subject.method(:description))

      events = @subject.instance_variable_get(:@__events__)
      events[:foo].length.should == 0
      observing_object.unobserve_all
    end

    it 'calls other event procs when a proc unregisters itself' do
      @proxy.proof = 0
      proof1 = proc do |r|
        @proxy.proof += r
        @subject.off(:foo, &proof1)
      end
      proof2 = proc do |r|
        @proxy.proof += r
      end
      @subject.on(:foo, &proof1)
      @subject.on(:foo, &proof2)
      @subject.trigger(:foo, 2)
      @proxy.proof.should == 4
    end
  end

  describe '.trigger' do
    it 'calls event procs' do
      @proxy.proof = false
      @subject.on(:foo) do |r|
        @proxy.proof = r
      end
      @subject.trigger(:foo, true)
      @proxy.proof.should == true
    end

    it 'calls event methods' do
      @proxy.proof = false
      def bar(r)
        @proxy.proof = r
      end
      @subject.on(:foo, method(:bar))
      @subject.trigger(:foo, true)
      @proxy.proof.should == true
    end

    it 'calls event procs for correct event' do
      @proxy.proof = false
      @subject.on(:foo) do |r|
        @proxy.proof = r
      end
      @subject.trigger(:bar, true)
      @proxy.proof.should == false
    end

    it 'calls event methods for correct event' do
      @proxy.proof = false
      def bar(r)
        @proxy.proof = r
      end
      @subject.on(:foo, method(:bar))
      @subject.trigger(:bar, true)
      @proxy.proof.should == false
    end

    it 'calls all the event procs' do
      @proxy.proof = 0
      @subject.on(:foo) { |r| @proxy.proof += r }
      @subject.on(:foo) { |r| @proxy.proof += r }
      @subject.on(:foo) { |r| @proxy.proof += r }
      @subject.trigger(:foo, 2)
      @proxy.proof.should == 6
    end

    it 'calls all the event methods' do
      def bar(r); @proxy.proof += r; end
      def baz(r); @proxy.proof += r; end
      @proxy.proof = 0
      @subject.on(:foo, method(:baz))
      @subject.on(:foo, method(:bar))
      @subject.trigger(:foo, 2)
      @proxy.proof.should == 4
    end

    class TestUIViewControllerWithEventable
      include BubbleWrap::Reactor::Eventable
      def test_on
        on(:foo) do
        end
        method(:bar)
      end

      def bar
      end

      def dealloc
        $test_dealloc = true
        super
      end
    end

    describe 'memory implications' do

      it 'does not cause a retain-cycle prior to loading __events__' do
        autorelease_pool do
          $test_dealloc = false
          TestUIViewControllerWithEventable.alloc.init
        end
        wait 0 do
          $test_dealloc.should == true
        end
      end

      it 'does not cause a retain-cycle after calling trigger' do
        autorelease_pool do
        autorelease_pool do
          $test_dealloc = false
          obj = TestUIViewControllerWithEventable.alloc.init
          obj.trigger(:something)
        end
        end
        wait 0 do
          $test_dealloc.should == true
        end
      end

      it 'does not cause a retain-cycle after loading __events__' do
        autorelease_pool do
          $test_dealloc = false
          obj = TestUIViewControllerWithEventable.alloc.init
          obj.send(:__events__)
        end
        wait 0 do
          $test_dealloc.should == true
        end
      end

      it 'does not cause a retain-cycle after adding an event' do
        autorelease_pool do
          $test_dealloc = false
          obj = TestUIViewControllerWithEventable.alloc.init
          obj.test_on
        end
        wait 0 do
          $test_dealloc.should == true
        end
      end

    end
  end

end

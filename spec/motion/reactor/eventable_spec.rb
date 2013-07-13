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
    it 'registers events' do
      proof = proc {  }
      @subject.on(:foo, &proof)
      events = @subject.instance_variable_get(:@__events__)
      events[:foo].member?(proof).should == true
    end

    it 'returns the array of blocks for the event' do
      proof = proc {  }
      @subject.on(:foo, &proof).should == [proof]
    end
  end

  describe '.off' do
    it 'unregisters events' do
      proof = proc { }
      @subject.on(:foo, &proof)
      events = @subject.instance_variable_get(:@__events__)
      @subject.off(:foo, &proof)
      events[:foo].member?(proof).should == false
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

    it 'calls all the event procs' do
      @proxy.proof = 0
      @subject.on(:foo) { |r| @proxy.proof += r }
      @subject.on(:foo) { |r| @proxy.proof += r }
      @subject.on(:foo) { |r| @proxy.proof += r }
      @subject.trigger(:foo, 2)
      @proxy.proof.should == 6
    end

    describe 'memory implications' do
      before do
        @did_work = false
        dealloc_proc = proc { |x| @did_work = true }
        @klass = Class.new do
          include BubbleWrap::Reactor::Eventable
        end
        @object = @klass.new
        ObjectSpace.define_finalizer(@object, &dealloc_proc)
      end

      it 'does not cause a retain-cycle prior to calling trigger' do
        @object = nil
        wait 0 do
          @did_work.should == true
        end
      end

      it 'does not cause a retain-cycle after calling trigger' do
        @object.trigger(:something)
        @object = nil
        wait 0 do
          @did_work.should == true
        end
      end

    end
  end

end

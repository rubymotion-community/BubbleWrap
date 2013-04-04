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
      events = @subject.instance_variable_get(:@events)
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
      events = @subject.instance_variable_get(:@events)
      @subject.off(:foo, &proof)
      events[:foo].member?(proof).should == false
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
  end

end

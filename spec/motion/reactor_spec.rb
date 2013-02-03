describe BubbleWrap::Reactor do
  before do
    @subject = ::BubbleWrap::Reactor
    @proxy = Class.new do
      attr_accessor :proof
    end.new
  end

  describe 'slavish EventMachine compatibility' do
    describe '.reactor_running?' do
      it 'returns true' do
        @subject.reactor_running?.should == true
      end
    end

    describe '.reactor_thread?' do
      it 'returns true' do
        @subject.reactor_running?.should == true
      end
    end
  end

  describe '.add_timer' do
    it 'schedules and executes timers' do
      @proxy.proof = false
      @subject.add_timer 0.5 do
        @proxy.proof = true
      end
      wait_for_change @proxy, 'proof' do
        @proxy.proof.should == true
      end
    end

    it 'only runs the callback once' do
      @proxy.proof = 0
      @subject.add_timer 0.1 do
        @proxy.proof = @proxy.proof + 1
      end
      wait 1 do
        @proxy.proof.should == 1
      end
    end
  end

  describe '.add_periodic_timer' do
    it 'runs callbacks repeatedly' do
      @proxy.proof = 0
      @timer = @subject.add_periodic_timer 0.5 do
        @proxy.proof = @proxy.proof + 1
        @subject.cancel_timer(@timer) if @proxy.proof > 2
      end
      wait 1.1 do
        @proxy.proof.should >= 2
      end
    end

    it 'accepts non-block callbacks' do
      @proxy.proof = 0
      callback = lambda {
        @proxy.proof = @proxy.proof + 1
        @subject.cancel_timer(@timer) if @proxy.proof > 2
      }
      @timer = @subject.add_periodic_timer 0.5, callback
      wait 1.1 do
        @proxy.proof.should >= 2
      end
    end

    it 'runs callbacks repeatedly in common runloop modes' do
      @proxy.proof = 0
      @timer = @subject.add_periodic_timer 0.5, :common_modes => true do
        @proxy.proof = @proxy.proof + 1
        @subject.cancel_timer(@timer) if @proxy.proof > 2
      end
      wait 1.1 do
        @proxy.proof.should >= 2
      end
    end
  end

  describe '.cancel_timer' do
    it 'cancels timers' do
      @proxy.proof = true
      timer = @subject.add_timer 10.0 do
        @proxy.proof = false
      end
      @subject.cancel_timer(timer)
      @proxy.proof.should == true
    end

    it 'cancels periodic timers' do
      @proxy.proof = true
      timer = @subject.add_periodic_timer 10.0 do
        @proxy.proof = false
      end
      @subject.cancel_timer(timer)
      @proxy.proof.should == true
    end

    it 'cancels common modes periodic timers' do
      @proxy.proof = true
      timer = @subject.add_periodic_timer 10.0, :common_modes => true do
        @proxy.proof = false
      end
      @subject.cancel_timer(timer)
      @proxy.proof.should == true
    end
  end

  describe '.defer' do
    it 'defers the operation' do
      @proxy.proof = false
      @subject.defer do
        @proxy.proof = true
      end
      @proxy.proof.should == false
      wait 0.5 do
        @proxy.proof.should == true
      end
    end

    it 'calls the callback after the operation finishes' do
      @proxy.proof = false
      cb = proc do |result|
        @proxy.proof = result
      end
      op = proc do
        true
      end
      @subject.defer(op,cb)
      wait 0.5 do
        @proxy.proof.should == true
      end
    end
  end

  describe '.schedule' do
    it 'defers the operation' do
      @proxy.proof = false
      @subject.schedule do
        @proxy.proof = true
      end
      @proxy.proof.should == false
      wait 0.5 do
        @proxy.proof.should == true
      end
    end

# I wish these specs would run, but they kill RubyMotion. *sad face*

#     it 'runs the operation on the reactor queue' do
#       @proxy.proof = false
#       @subject.schedule do
#         @proxy.proof = ::Reactor::Queue.current.to_s
#       end
#       wait 0.75 do
#         @proxy.proof.should == "#{NSBundle.mainBundle.bundleIdentifier}.reactor"
#       end
#     end

#     it 'runs the callback on the main queue' do
#       @proxy.proof = false
#       @subject.schedule do
#         @proxy.proof = ::Reactor::Queue.current.to_s
#       end
#       wait 0.75 do
#         @proxy.proof.should == ::Reactor::Queue.main.to_s
#       end
#     end
  end

  describe '.schedule_on_main' do
    it 'defers the operation' do
      @proxy.proof = false
      @subject.schedule do
        @proxy.proof = true
      end
      @proxy.proof.should == false
      wait 0.5 do
        @proxy.proof.should == true
      end
    end

#     it 'runs the operation on the main queue' do
#       @proxy.proof = false
#       @subject.schedule do
#         @proxy.proof = ::Reactor::Queue.current.to_s
#       end
#       wait 0.75 do
#         @proxy.proof.should == ::Reactor::Queue.main.to_s
#       end
#     end
  end

end

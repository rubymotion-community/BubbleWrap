describe BubbleWrap::Reactor::DependentDeferrable do

  before do
    @subject = Class.new do
      include BubbleWrap::Reactor::Deferrable
    end
    @d1 = @subject.new
    @d2 = @subject.new
    @object = BubbleWrap::Reactor::DependentDeferrable.on(@d1, @d2)
  end

  describe '.callback' do

    it "calls the callback block with arguments after all children .succeed" do
      args1 = [1, 2]
      args2 = [3, 4]
      @object.callback do |*passed_args|
        passed_args.should.equal [args1, args2]
      end
      @d1.succeed *args1
      @d2.succeed *args2
    end

    it "calls the callback block with arguments only after all children .succeed" do
      execution_order = []
      @object.callback do |*passed_args|
        execution_order << 3
      end
      execution_order << 1
      @d1.succeed :succeeds
      execution_order << 2
      @d2.succeed :succeeds
      execution_order.should.equal [1, 2, 3]
    end

    it "calls the callback if even if the deferrable already succeeded" do
      @d1.succeed :succeeded1
      @d2.succeed :succeeded2
      @object.callback do |*args|
        NSLog "args: #{args} class: #{args.class}"
        args[0].should.equal [:succeeded1]
        args[1].should.equal [:succeeded2]
      end
    end

  end

  describe '.errback' do
    it "calls the errback block after a child fails" do
      args1 = [1, 2]
      args2 = [3, 4]
      @object.errback do |*passed_args|
        passed_args.should.equal args1
      end
      @d1.fail *args1
    end

    it "calls the errback block immediately after a child fails" do
      execution_order = []
      @object.errback do |*passed_args|
        execution_order << 2
      end
      execution_order << 1
      @d1.fail :fail
      execution_order << 3
      @d2.fail :fail
      execution_order.should.equal [1, 2, 3]
    end

    it "calls the errback block after a child fails even if others succeeds" do
      args1 = [1, 2]
      args2 = [3, 4]
      callback_called = false
      @object.callback do |*passed_args|
        callback_called = true
      end
      @object.errback do |*passed_args|
        passed_args.should.equal args2
      end
      @d1.succeed *args1
      @d2.fail *args2
      callback_called.should.equal false
    end

    it "calls the errback block even if the deferrable failed first" do
      @d1.fail :err
      @object.errback do |err|
        err.should.equal :err
      end
    end
  end

end

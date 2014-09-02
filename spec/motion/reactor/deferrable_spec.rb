describe BubbleWrap::Reactor::Deferrable do

  before do
    @subject = Class.new do
      include BubbleWrap::Reactor::Deferrable
    end
    @object = @subject.new
  end

  describe '.callback' do

    it "calls the callback block with arguments after .succeed" do
      args = [1, 2]
      @object.callback do |*passed_args|
        passed_args.should.equal args
      end
      @object.succeed *args
    end

    it "calls the callback if even if the deferrable already suceeded" do
      @object.succeed :succeeded
      @object.callback do |*args|
        args[0].should.equal :succeeded
      end
    end

  end

  describe '.errback' do
    it "calls the errback block after the deferrable fails" do
      args = [1, 2]
      @object.errback do |*passed_args|
        passed_args.should.equal args
      end
      @object.fail *args
    end

    it "calls the errback block even if the deferrable failed first" do
      @object.fail :err
      @object.errback do |err|
        err.should.equal :err
      end
    end
  end

  describe '.delegate' do
    it "passes the delegate to both .errback_delegate and .callback_delegate" do
      @object.define_singleton_method(:callback_delegate) { |d| @callback_delegated = true }
      @object.define_singleton_method(:errback_delegate) { |d| @errback_delegated = true }

      @object.delegate(@subject.new)
      @object.instance_variable_get("@callback_delegated").should.equal true
      @object.instance_variable_get("@errback_delegated").should.equal true
    end
  end

  describe '.errback_delegate' do
    it "calls the delegate errback method when the deferrable fails" do
      delegate = @subject.new
      @object.errback_delegate delegate

      delegate.errback do |*args|
        args[0].should.equal :err
      end
      @object.fail :err
    end
  end

  describe '.callback_delegate' do
    it "calls the delegate callback when the deferrable suceeds" do
      delegate = @subject.new
      @object.callback_delegate delegate

      delegate.callback do |*args|
        args[0].should.equal :passed
      end
      @object.succeed :passed
    end
  end

end

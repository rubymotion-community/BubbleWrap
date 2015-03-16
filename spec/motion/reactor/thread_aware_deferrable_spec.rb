shared :queue_caching_deferrable_method do
  it "stores the current queue that is being used when a callback is added" do
    @subject.send(@method, &@blk)
    cache = @subject.instance_variable_get("@queue_cache")
    cache.should.not.be.nil
    cache[@blk.object_id].to_s.should.equal Dispatch::Queue.main.to_s
  end

  it "stores the queue, even if its not the main" do
    @queue.async do 
      @subject.send(@method, &@blk)
      Dispatch::Queue.main.async { resume }
    end
    wait do
      cache = @subject.instance_variable_get("@queue_cache")
      cache.should.not.be.nil
      cache[@blk.object_id].to_s.should.equal @queue.to_s
    end
  end
end

shared :queue_block_execution do
  it "calls the block on the right thread, with deferred argument once the deferrable is finished" do
    @queue.async do 
      @subject.send(@block_method) do |*args|
        Dispatch::Queue.current.to_s.should.equal @queue.to_s
        args.should.equal [true]
        Dispatch::Queue.main.async { resume }
      end
    end
    @subject.send(@status_method, true)

    wait {}
  end

  it "removes the queue from internal cache once the deferrable is finished" do
    @subject.send(@block_method) do |*args| 
      Dispatch::Queue.main.async { resume }
    end
    @subject.send(@status_method, true)

    wait do
      @subject.instance_variable_get("@queue_cache").length.should.equal 0
    end
  end
end

describe BubbleWrap::Reactor::ThreadAwareDeferrable do

  before do
    @subject = BubbleWrap::Reactor::ThreadAwareDeferrable.new
    @queue = Dispatch::Queue.new(:test_queue.to_s)
    @blk = Proc.new {|*args| }
  end

  describe '.callback' do
    before do
      @method = :callback
    end
    behaves_like :queue_caching_deferrable_method
  end

  describe '.errback' do
    before do
      @method = :errback
    end
    behaves_like :queue_caching_deferrable_method
  end

  describe '.succeed' do
    before do
      @block_method = :callback
      @status_method = :succeed
    end
    behaves_like :queue_block_execution
  end

  describe '.fail' do
    before do
      @block_method = :callback
      @status_method = :succeed
    end
    behaves_like :queue_block_execution
  end
end

describe BubbleWrap::Reactor::ThreadAwareDeferrable do

  before do
    @subject = BubbleWrap::Reactor::ThreadAwareDeferrable.new
    @queue = Dispatch::Queue.new(:test_queue.to_s)
    @blk = Proc.new {|*args| }
  end

  def resume_on_main
    Dispatch::Queue.main.async { resume }
  end

  describe '.callback' do
    it "stores the current queue that is being used when a callback is added" do

      @subject.callback &@blk

      wait_max 3.0 {}
      true.should.equal true


    end
  end

  describe '.errback' do

  end

  describe '.succeed' do

  end

  describe '.fail' do

  end
end

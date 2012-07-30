describe BubbleWrap::Persistence do

  describe '.app_key' do

    it "caches the @app_key" do
      BubbleWrap::Persistence.instance_variable_get(:@app_key).should.equal nil
      BubbleWrap::Persistence.app_key
      BubbleWrap::Persistence.instance_variable_get(:@app_key).should.not.equal nil
    end

    it 'delegates to BubbleWrap::App.idenfitier' do
      BubbleWrap::Persistence.app_key.should == BubbleWrap::App.identifier
    end

  end


  describe "storing objects" do
    it 'can persist simple objects' do
      lambda do
        BubbleWrap::Persistence['arbitraryNumber'] = 42
      end.
        should.not.raise(Exception)
    end

    it "must call synchronize" do
      storage = NSUserDefaults.standardUserDefaults
      def storage.synchronize; @sync_was_called = true; end

      BubbleWrap::Persistence['arbitraryNumber'] = 42
      storage.instance_variable_get(:@sync_was_called).should.equal true
    end
  end

  describe "storing multiple objects" do
    it 'can persist multiple objects' do
      lambda do
        BubbleWrap::Persistence.merge({
          :anotherArbitraryNumber => 9001,
          :arbitraryString => 'test string'
        })
      end.
        should.not.raise(Exception)
    end

    it 'must call synchronize' do
      storage = NSUserDefaults.standardUserDefaults
      def storage.synchronize; @sync_was_called = true; end

      BubbleWrap::Persistence.merge({
        :anotherArbitraryNumber => 9001,
        :arbitraryString => 'test string'
      })
      storage.instance_variable_get(:@sync_was_called).should.equal true
    end
  end

  describe "retrieving objects" do
    it 'can retrieve persisted objects' do
      BubbleWrap::Persistence['arbitraryNumber'].should == 42
      BubbleWrap::Persistence[:arbitraryString].should == 'test string'
    end

    it 'returns fully functional strings' do
      BubbleWrap::Persistence[:arbitraryString].methods.should == 'test string'.methods
    end
  end
end

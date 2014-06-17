class ArchivableClass
  attr_accessor :value
  def initWithCoder(decoder)
    self.init

    @value = decoder.decodeObjectForKey("value")

    self
  end

  def encodeWithCoder(encoder)
    encoder.encodeObject(@value, forKey: "value")
  end
end

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

  describe "retrieving all objects" do
    it 'can retrieve a dictionary of all objects' do
      all = BubbleWrap::Persistence.all
      all.is_a?(Hash).should == true

      compare_to = {}
      compare_to["anotherArbitraryNumber"] = 9001
      compare_to["arbitraryNumber"]        = 42
      compare_to["arbitraryString"]        = "test string"

      compare_to.each do |key, value|
        all[key].should == value
      end
    end
  end

  describe "deleting object" do
    before do
      BubbleWrap::Persistence['arbitraryString'] = 'foobarbaz'
    end

    it 'can delete persisted object' do
      BubbleWrap::Persistence.delete(:arbitraryString).should == 'foobarbaz'
      BubbleWrap::Persistence['arbitraryString'].should.equal nil
    end

    it 'returns nil when the object does not exist' do
      BubbleWrap::Persistence.delete(:wrongKey).should == nil
    end

    it 'must call synchronize' do
      storage = NSUserDefaults.standardUserDefaults
      def storage.synchronize; @sync_was_called = true; end

      BubbleWrap::Persistence.delete(:arbitraryString)

      storage.instance_variable_get(:@sync_was_called).should.equal true
    end

  end

  describe "archive" do
    before do
      @subject = ArchivableClass.new
      @subject.value = 123
    end

    it 'can persist an object' do
      lambda do
        BubbleWrap::Persistence::Archive['an_object'] = @subject
      end.
        should.not.raise(Exception)

      BubbleWrap::Persistence['an_object'].should.not == nil
    end

    it 'can retrieve a persisted object' do
      BubbleWrap::Persistence::Archive['another_object'] = @subject
      retrieved = BubbleWrap::Persistence::Archive[:another_object]
      retrieved.should.be.kind_of(ArchivableClass)
      retrieved.value.should == @subject.value
    end

    it 'can persist arrays of objects' do
      other_subject = ArchivableClass.new
      other_subject.value = 555

      BubbleWrap::Persistence::Archive['array_of_objects'] = [@subject, other_subject, 123]

      retrieved = BubbleWrap::Persistence::Archive[:array_of_objects]
      retrieved.should.be.kind_of(Array)
      retrieved.length.should == 3
      retrieved[0].should.be.kind_of(ArchivableClass)
      retrieved[0].value.should == @subject.value
      retrieved[1].value.should == other_subject.value
      retrieved[2].should == 123
    end

    it 'can persist hashes of objects' do
      BubbleWrap::Persistence::Archive['hash_of_objects'] = {first: @subject}

      retrieved = BubbleWrap::Persistence::Archive[:hash_of_objects]
      retrieved.should.be.kind_of(Hash)
      retrieved['first'].should.be.kind_of(ArchivableClass)
      retrieved['first'].value.should == @subject.value
    end

    it 'cannot save NSData' do
      lambda do
        BubbleWrap::Persistence::Archive['some_data'] = NSData.new
      end.
        should.raise(Exception)
    end

  end
end

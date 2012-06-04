describe BubbleWrap::Persistence do

  describe '.app_key' do
    it 'delegates to BubbleWrap::App.idenfitier' do
      BubbleWrap::Persistence.app_key.should == BubbleWrap::App.identifier
    end
  end

  it 'can persist simple objects' do
    lambda do
      BubbleWrap::Persistence['arbitraryNumber'] = 42
    end.
      should.not.raise(Exception)
  end

  it 'can retrieve persisted objects' do
    BubbleWrap::Persistence['arbitraryNumber'].should == 42
  end

end

describe "NSIndexPathWrap" do

  before do
    @index = NSIndexPath.indexPathForRow(0, inSection:3) 
  end

  it "should be able to use an array like accessor" do
    @index[0].should == @index.indexAtPosition(0)
  end

  it "should support the each iterator" do
    i = []
    @index.each do |idx|
      i << idx
    end
    i.should == [3, 0]
  end

end

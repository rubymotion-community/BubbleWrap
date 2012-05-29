describe "NSIndexPathWrap" do

  it "should be able to use an array like accessor" do
    index = NSIndexPath.indexPathForRow(0, inSection:3)
    index[0].should == index.indexAtPosition(0)
  end

  it "should support the each iterator" do
    index = NSIndexPath.indexPathForRow(0, inSection:2)
    puts index.inspect
    i = []
    index.each do |idx|
      i << idx
    end
    i.should == [2, 0]
  end

end

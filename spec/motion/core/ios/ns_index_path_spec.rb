describe "NSIndexPathWrap" do

  before do
      @index = NSIndexPath.indexPathForRow(0, inSection:3)
  end

  it "should support #+ and #-" do
    @index = @index + 1
    @index.row.should == 1
    @index = @index + 1
    @index.row.should == 2
    @index = @index + 12
    @index.row.should == 14
    @index = @index - 3
    @index.row.should == 11
    @index = @index - 0
    @index.row.should == 11
  end

end

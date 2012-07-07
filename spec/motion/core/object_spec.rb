describe BubbleWrap::Object do
  describe '.delegate_new_to_alloc_init' do
    it 'sends methods starting with new to .alloc.init...' do
      lambda {
        @ui_view = UIView.newWithFrame [[0,0],[0,0]]
      }.should.not.raise NoMethodError

      @ui_view.class.should.equal UIView
    end

    it 'supports methods with inline arguments' do
      lambda {
        @ui_color = UIColor.newWithRed 1.0, green: 1.0, blue: 1.0, alpha: 1.0
      }.should.not.raise NoMethodError

      @ui_color.alphaComponent.should.equal 1.0
    end

    it 'delegates other methods to super' do
      lambda {
        Object.someOtherNonexistentMethod
      }.should.raise NoMethodError
    end
  end
end

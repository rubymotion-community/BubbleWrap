describe BubbleWrap::String do

  describe ::String do
    it 'should include BubbleWrap::String' do
      ::String.ancestors.member?(BubbleWrap::String).should == true
    end
  end

  describe 'CamelCase input' do
    describe '.camelize(true)' do
      it "doesn't change the value" do
        'CamelCase'.camelize(true).should == 'CamelCase'
      end
    end

    describe '.camelize(false)' do
      it 'lower cases the first character' do
        'CamelCase'.camelize(false).should == 'camelCase'
      end
    end

    describe '.underscore' do
      it 'converts it to underscores' do
        'CamelCase'.underscore.should == 'camel_case'
      end
    end
  end

  describe 'camelCase input' do
    describe '.camelize(true)' do
      it "upper cases the first character" do 
        'camelCase'.camelize(true).should == 'CamelCase'
      end
    end

    describe '.camelize(false)' do
      it "doesn't change the value" do
        'camelCase'.camelize(false).should == 'camelCase'
      end
    end

    describe '.underscore' do
      it 'converts it to underscores' do
        'camelCase'.underscore.should == 'camel_case'
      end
    end
  end

  describe 'snake_case input' do
    describe '.camelize(true)' do
      it 'converts to CamelCase' do
        'snake_case'.camelize(true).should == 'SnakeCase'
      end
    end

    describe '.camelize(false)' do
      it 'converts to camelCase' do
        'snake_case'.camelize(false).should == 'snakeCase'
      end
    end

    describe '.underscore' do
      it "doesn't change the value" do
        'snake_case'.underscore.should == @test_string
      end
    end
  end

end

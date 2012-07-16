require File.expand_path('../../../../../lib/bubble-wrap/requirement/path_manipulation', __FILE__)

describe BubbleWrap::Requirement::PathManipulation do

  before do
    @subject = Object.new
    @subject.extend BubbleWrap::Requirement::PathManipulation
  end

  describe '#convert_caller_to_path' do
    it 'strips off from the second-to-last colon' do
      @subject.convert_caller_to_path("/fake/:path/foo:91:in `fake_method'").
        should == '/fake/:path'
    end

    it 'leaves plain old paths unmolested' do
      @subject.convert_caller_to_path("/fake/path").
        should == '/fake/path'
    end
  end

  describe '#convert_to_absolute_path' do
    it 'converts relative paths to absolute paths' do
      @subject.convert_to_absolute_path('foo')[0].should == '/'
    end

    it "doesn't modify absolute paths" do
      @subject.convert_to_absolute_path('/foo').should == '/foo'
    end
  end

  describe '#strip_up_to_last_lib' do
    it 'strips off from the last lib' do
      @subject.strip_up_to_last_lib('/fake/lib/dir/lib/foo').
        should == '/fake/lib/dir'
    end

    it "strips off only a trailing lib" do
      @subject.strip_up_to_last_lib('/fake/lib/dir/lib').
        should == '/fake/lib/dir'
    end

    it "doesn't modify the path otherwise" do
      @subject.strip_up_to_last_lib('/fake/path').
        should == '/fake/path'
    end
  end

  describe "#convert_to_relative" do
    it 'strips off the root portion' do
      @subject.convert_to_relative('/foo/bar/baz', '/foo').
        should == 'bar/baz'
    end
  end
end

require 'mocha-on-bacon'
require File.expand_path('../../../motion_stub', __FILE__)
require 'bubble-wrap'

describe BubbleWrap::Ext::ConfigTask do

  before do
    klass = Class.new do
      def initialize
        @files = [ '/fake/a', '/fake/b' ]
        @dependencies = {}
      end

      def files_dependencies
      end
    end
    klass.send(:include, BubbleWrap::Ext::ConfigTask)
    @subject = klass.new
  end

  describe '.included' do
    it 'aliases :files_dependencies to :files_dependencies_without_bubblewrap' do
      @subject.respond_to?(:files_dependencies_without_bubblewrap).should == true
    end

    it 'aliass :files_dependencies_with_bubblewrap to :files_dependencies' do
      @subject.method(:files_dependencies).should == @subject.method(:files_dependencies_with_bubblewrap)
    end
  end

  describe '#path_matching_expression' do
    it 'returns a regular expression' do
      @subject.path_matching_expression.is_a?(Regexp).should == true
    end
  end

  describe '#files_dependencies_with_bubblewrap' do
    it 'should call #path_matching_expression' do
      @subject.expects(:path_matching_expression).twice().returns(/^\.?\//)
      @subject.files_dependencies_with_bubblewrap '/fake/a' => '/fake/b'
    end
  end

end

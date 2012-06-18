require 'mocha-on-bacon'
require File.expand_path('../../../motion_stub', __FILE__)
require 'bubble-wrap'

describe BubbleWrap::Ext::BuildTask do

  before do
    @subject = Class.new do
      def self.setup; end
      def self.configs
        @configs ||= { :development => Object.new }
      end
    end
    @subject.extend BubbleWrap::Ext::BuildTask
    @default_frameworks = ['CoreGraphics', 'Foundation', 'UIKit']
  end

  describe '.extended' do
    it 'responds to :setup_with_bubblewrap' do
      @subject.respond_to?(:setup_with_bubblewrap).should == true
    end

    it 'responds to :setup_without_bubblewrap' do
      @subject.respond_to?(:setup_without_bubblewrap).should == true
    end

    it 'replaces :setup with :setup_with_bubblewrap' do
      @subject.method(:setup).should == @subject.method(:setup_with_bubblewrap)
    end
  end

  describe '.setup_with_bubblewrap' do
    before do
      @config = @subject.configs[:development]
      @config.stubs(:files=)
      @config.stubs(:files)
      @config.stubs(:files_dependencies)
      @config.stubs(:frameworks)
      @config.stubs(:frameworks=)
      @subject.stubs(:config).returns(mock())
      @subject.config.stubs(:validate)
    end

    it 'calls the passed-in block' do
      block = proc { }
      block.expects(:call).with(@config)
      @subject.setup &block
    end

    describe 'when app.files is nil' do
      it 'sets app.files' do
        @config.stubs(:files).returns(nil)
        files = BubbleWrap::Requirement.files
        @config.expects(:files=).with(files)
        @subject.setup
      end
    end

    describe 'when app.files is empty' do
      it 'sets app.files' do
        @config.stubs(:files).returns([])
        files = BubbleWrap::Requirement.files
        @config.expects(:files=).with(files)
        @subject.setup
      end
    end

    describe 'when app.files has contents' do
      it 'sets app.files' do
        mock_files = ['a', 'b', 'c']
        @config.stubs(:files).returns(mock_files)
        files = BubbleWrap::Requirement.files + mock_files
        @config.expects(:files=).with(files)
        @subject.setup
      end
    end

    it 'removes duplicates from app.files' do
      files = ['a', 'a', 'b', 'b', 'c', 'c']
      @config.stubs(:files).returns(files)
      @config.expects(:files=).with(BubbleWrap::Requirement.files + files.uniq)
      @subject.setup
    end

    it 'adds BW dependencies' do
      @config.expects(:files_dependencies).with(BubbleWrap::Requirement.files_dependencies)
      @subject.setup
    end

    describe 'when app.frameworks is empty' do
      it 'sets the default frameworks' do
        @config.stubs(:frameworks).returns(nil)
        @config.expects(:frameworks=).with(@default_frameworks)
        @subject.setup
      end
    end

    describe 'when app.frameworks is empty' do
      it 'sets the default frameworks' do
        @config.stubs(:frameworks).returns([])
        @config.expects(:frameworks=).with(@default_frameworks)
        @subject.setup
      end
    end

    describe 'when app.frameworks contains defaults' do
      it 'sets the default frameworks' do
        @config.stubs(:frameworks).returns(@default_frameworks)
        @config.expects(:frameworks=).with(@default_frameworks)
        @subject.setup
      end
    end

    describe 'when app.frameworks contains non-defaults' do
      it 'sets the default frameworks and the contents' do
        @config.stubs(:frameworks).returns(['Addressbook'])
        @config.expects(:frameworks=).with(['Addressbook'] + @default_frameworks)
        @subject.setup
      end
    end

    describe 'when BW::Requirement.frameworks has contents' do
      it 'sets the default frameworks and the contents' do
        BW.require('motion/core.rb') do
          file('motion/core.rb').uses_framework('Addressbook')
        end
        @config.stubs(:frameworks).returns(nil)
        @config.expects(:frameworks=).with(['Addressbook'] + @default_frameworks)
        @subject.setup
      end
    end
  end

end

require File.expand_path('../../motion_stub', __FILE__)
require 'bubble-wrap'

describe BubbleWrap::Requirement do

  before do
    @subject = BubbleWrap::Requirement
  end

  describe '.scan' do
    before do
      @subject.clear!
      @root_path = File.expand_path('../../../../', __FILE__) 
    end

    it 'asking for a not-yet-found file raises an exception' do
      should.raise(Exception) do 
        @subject.find('foo')
      end
    end

    it 'finds the specified file' do
      @subject.scan(@root_path, 'motion/core.rb')
      @subject.paths.keys.should.include 'motion/core.rb'
    end

    it 'finds multiple files according to spec' do
      @subject.scan(@root_path, 'motion/**/*.rb')
      @subject.files.size.should > 1
    end

    it 'never depends on itself' do
      @subject.scan(@root_path, 'motion/core.rb') do
        file('motion/core.rb').depends_on 'motion/core.rb'
      end
      @subject.file('motion/core.rb').file_dependencies.should.not.include 'motion/core.rb'
    end

    it 'can depend on another file' do
      @subject.scan(@root_path, 'motion/*.rb') do
        file('motion/http.rb').depends_on('motion/core.rb')
      end
      @subject.file('motion/http.rb').file_dependencies.should.include @subject.file('motion/core.rb')
    end

    it 'can use a framework' do
      @subject.scan(@root_path, 'motion/core.rb') do
        file('motion/core.rb').uses_framework('FakeFramework')
      end
      @subject.file('motion/core.rb').frameworks.member?('FakeFramework').should == true
    end

    it "figures out the root of the project" do
      @subject.scan(File.join(@root_path, 'lib/bubble-wrap.rb'), 'motion/core.rb')
      @subject.paths.values.first.root.should == @root_path
    end

    describe '.frameworks' do
      it 'includes UIKit by default' do
        @subject.frameworks.member?('UIKit').should == true
      end

      it 'includes Foundation by default' do
        @subject.frameworks.member?('Foundation').should == true
      end

      it 'includes CoreGraphics by default' do
        @subject.frameworks.member?('CoreGraphics').should == true
      end
    end
  end

end

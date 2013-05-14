unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

unless defined?(BubbleWrap::LOADER_PRESENT)
  require 'bubble-wrap/version' unless defined?(VERSION)
  if Gem::Version.new(Motion::Version) < Gem::Version.new(BubbleWrap::MIN_MOTION_VERSION)
    raise "BubbleWrap #{BubbleWrap::VERSION} requires at least RubyMotion #{BubbleWrap::MIN_MOTION_VERSION}"
  end

  require 'bubble-wrap/ext'
  require 'bubble-wrap/requirement'

  module BubbleWrap

    LOADER_PRESENT=true
    module_function

    def root
      File.expand_path('../../../', __FILE__)
    end

    def require(file_spec, &block)
      Requirement.scan(caller.first, file_spec, &block)
    end

    def require_ios(requirement = nil, &callback)
      if !Motion::Project::App.osx?
        callback.call
      else
        puts "bubble-wrap/#{requirement} requires iOS to use." if requirement
      end
    end

    def require_osx(requirement = nil, &callback)
      if Motion::Project::App.osx?
        callback.call
      else
        puts "bubble-wrap/#{requirement} requires OS X to use." if requirement
      end
    end
  end

  BW = BubbleWrap unless defined?(BW)

  BW.require 'motion/shortcut.rb'
  
end

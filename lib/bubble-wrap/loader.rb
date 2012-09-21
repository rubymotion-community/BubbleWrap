unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

unless defined?(BubbleWrap::LOADER_PRESENT)
  require 'bubble-wrap/version' unless defined?(VERSION)
  if BubbleWrap::minor_version(Motion::Version) < BubbleWrap::minor_version(BubbleWrap::MIN_MOTION_VERSION)
    raise "BubbleWrap #{BubbleWrap::VERSION} requires at least rubymotion #{BubbleWrap::MIN_MOTION_VERSION}"
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

  end

  BW = BubbleWrap unless defined?(BW)

  BW.require 'motion/shortcut.rb'
  
end

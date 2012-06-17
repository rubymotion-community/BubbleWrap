unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

unless defined?(BubbleWrap::LOADER_PRESENT)

  require 'bubble-wrap/version' unless defined?(VERSION)
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
  
end

unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

require "bubble-wrap/version" unless defined?(BubbleWrap::VERSION)
require File.expand_path('../bubble-wrap/ext', __FILE__)
require File.expand_path('../bubble-wrap/requirement', __FILE__)

module BubbleWrap

  module_function

  def root
    File.expand_path('../../', __FILE__)
  end

  def require(file_spec, &block)
    Requirement.scan(caller.first, file_spec, &block)
  end

end

BW = BubbleWrap

require File.expand_path('../bubble-wrap/core', __FILE__)
require File.expand_path('../bubble-wrap/http', __FILE__)

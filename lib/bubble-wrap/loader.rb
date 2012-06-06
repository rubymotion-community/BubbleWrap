unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

require 'bubble-wrap/version'
require 'bubble-wrap/ext'
require 'bubble-wrap/requirement'

module BubbleWrap

  module_function

  def root
    File.expand_path('../../../', __FILE__)
  end

  def require(file_spec, &block)
    Requirement.scan(caller.first, file_spec, &block)
  end

end

BW = BubbleWrap

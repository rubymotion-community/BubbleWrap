unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

require File.expand_path('../version', __FILE__) unless defined?(BubbleWrap::VERSION)
require File.expand_path('../ext', __FILE__)
require File.expand_path('../requirement', __FILE__)

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

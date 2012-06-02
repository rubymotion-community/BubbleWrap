unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

require "bubble-wrap/version" unless defined?(BubbleWrap::VERSION)
require File.expand_path "../bubble-wrap/ext/motion_project_config", __FILE__
require File.expand_path "../bubble-wrap/ext/motion_project_app", __FILE__
require File.expand_path "../bubble-wrap/requirement", __FILE__

module BubbleWrap

  module_function

  def root
    File.expand_path('../../', __FILE__)
  end

  def require(file_spec, &block)
    Requirement.scan(caller.first, file_spec, block)
  end

end

::BW = BubbleWrap

::BW.require('app/**/*.rb') do 
  file('app/bubble-wrap/device/screen.rb').depends_on 'app/bubble-wrap/device.rb'
  file('app/bubble-wrap/pollute.rb').depends_on 'app/bubble-wrap/ns_index_path.rb'
  file('app/bubble-wrap/pollute.rb').depends_on 'app/bubble-wrap/ui_control.rb'
end

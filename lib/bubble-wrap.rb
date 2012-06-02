unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

require "bubble-wrap/version"
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

# Motion::Project::App.setup do |app|
#   wrapper_files = []
#   app_location = File.expand_path('../app/**/*.rb', __FILE__)
#   puts app_location
#   exit
#   Dir.glob(File.join(File.dirname(__FILE__), 'bubble-wrap/**/*.rb')).each do |file|
#     app.files << file
#     wrapper_files << file
#   end
#   pollution_file = File.expand_path(File.join(File.dirname(__FILE__), 'pollute.rb'))
#   app.files.unshift pollution_file
#   app.files_dependencies pollution_file => wrapper_files
# end

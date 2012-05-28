require "bubble-wrap/version"

unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

Motion::Project::App.setup do |app|
  files = []
  Dir.glob(File.join(File.dirname(__FILE__), 'bubble-wrap/*.rb')).each do |file|
    app.files << file
  end
  pollution_file = File.join(File.dirname(__FILE__), 'pollute.rb')
  app.files << pollution_file
  app.files_dependencies pollution_file => files
end

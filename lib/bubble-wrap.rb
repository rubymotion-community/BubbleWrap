require "bubble-wrap/version"

Motion::Project::App.setup do |app|
  app.files.unshift(Dir.glob(File.join(File.dirname(__FILE__), 'bubble-wrap/*.rb')))
end
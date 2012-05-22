require "bubble-wrap/version"

Motion::Project::App.setup do |app|
  Dir.glob(File.join(File.dirname(__FILE__), 'bubble-wrap/*.rb')).each do |file|
    app.files.unshift(file)
  end
end
$:.unshift("/Library/Motion/lib")
require 'motion/project'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'MotionLibTestSuite'
  app.delegate_class = 'TestSuiteDelegate'
  app.files += Dir.glob('./lib/**.rb')
end

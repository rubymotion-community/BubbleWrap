require "bundler/gem_tasks"
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

Motion::Project::App.setup do |app|
  app.name = 'MotionLibTestSuite'
  app.delegate_class = 'TestSuiteDelegate'
  app.files += Dir.glob('./lib/bubble-wrap/**.rb')
end

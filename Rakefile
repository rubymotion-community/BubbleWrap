require "bundler/gem_tasks"
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

Motion::Project::App.setup do |app|
  app.name = 'MotionLibTestSuite'
  
  app.development do
    app.files << './lib/tests/test_suite_delegate.rb'
    app.delegate_class = 'TestSuiteDelegate'    
  end

  app.files += Dir.glob('./lib/bubble-wrap/**.rb')
end

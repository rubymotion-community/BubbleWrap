require 'bubble-wrap/loader'
BW.require 'motion/test_suite_delegate.rb'

Motion::Project::App.setup do |app|
  app.development do
    app.delegate_class = 'TestSuiteDelegate'
  end
end

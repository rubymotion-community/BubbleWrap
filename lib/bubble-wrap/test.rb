require 'bubble-wrap/loader'
BW.require 'motion/util/*.rb'
BW.require 'motion/test_suite_delegate.rb'

Motion::Project::App.setup do |app|
  app.development do
    if Motion::Project::App.osx?
      app.delegate_class = 'TestSuiteOSXDelegate'
    else
      app.delegate_class = 'TestSuiteDelegate'
    end
  end
end

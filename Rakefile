require "bundler/gem_tasks"
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require File.expand_path '../lib/bubble-wrap', __FILE__

Motion::Project::App.setup do |app|
  app.name = 'testSuite'
  app.identifier = 'io.bubblewrap.testSuite'

  app.files = []
  
  app.development do
    app.files << './lib/tests/test_suite_delegate.rb'
    app.delegate_class = 'TestSuiteDelegate'
  end

  # app.files += Dir.glob('./lib/bubble-wrap/**/*.rb')
  # wrapper_files = app.files.dup
  # pollution_file = Dir.glob('./lib/pollute.rb')[0]
  # app.files << pollution_file
  # app.files_dependencies pollution_file => wrapper_files
end

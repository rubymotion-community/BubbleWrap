require "bundler/gem_tasks"
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require File.expand_path '../lib/bubble-wrap', __FILE__
require File.expand_path '../lib/bubble-wrap/http', __FILE__

task :lib_spec do
  sh "bacon #{Dir.glob("lib_spec/**/*_spec.rb").join(' ')}"
end

task :test => [ :lib_spec, :spec ]

Motion::Project::App.setup do |app|
  app.name = 'testSuite'
  app.identifier = 'io.bubblewrap.testSuite'
  
  app.development do
    app.files << './lib/tests/test_suite_delegate.rb'
    app.delegate_class = 'TestSuiteDelegate'
  end
end

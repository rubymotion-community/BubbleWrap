require "bundler/gem_tasks"
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require File.expand_path '../lib/bubble-wrap', __FILE__
require File.expand_path '../lib/bubble-wrap/http', __FILE__
require File.expand_path '../lib/bubble-wrap/test', __FILE__

task :lib_spec do
  sh "bacon #{Dir.glob("lib_spec/**/*_spec.rb").join(' ')}"
end

task :test => [ :lib_spec, :spec ]

Motion::Project::App.setup do |app|
  app.name = 'testSuite'
  app.identifier = 'io.bubblewrap.testSuite'
end

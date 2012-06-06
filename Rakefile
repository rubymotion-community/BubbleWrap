require "bundler/gem_tasks"
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
Bundler.setup
Bundler.require

require 'bubble-wrap/test'

task :lib_spec do
  sh "bacon #{Dir.glob("lib_spec/**/*_spec.rb").join(' ')}"
end

task :test => [ :lib_spec, :spec ]

Motion::Project::App.setup do |app|
  app.name = 'testSuite'
  app.identifier = 'io.bubblewrap.testSuite'
end

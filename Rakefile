require "bundler/gem_tasks"
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
Bundler.setup
Bundler.require

require 'bubble-wrap/all'
require 'bubble-wrap/test'

Motion::Project::App.setup do |app|
  app.name = 'testSuite'
  app.identifier = 'io.bubblewrap.testSuite'
  app.specs_dir = './spec/motion'
  app.version = '1.2.3'
end

namespace :spec do
  task :lib do
    sh "bacon #{Dir.glob("spec/lib/**/*_spec.rb").join(' ')}"
  end

  task :motion => 'spec'

  task :all => [:lib, :motion]
end

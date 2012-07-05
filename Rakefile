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
  app.specs_dir = './spec/motion/'
  # Hold your breath, we're going API spelunking!
  spec_files = app.spec_files + Dir.glob(File.join(app.specs_dir, '**/*.rb'))
  spec_files.uniq!
  app.instance_variable_set(:@spec_files, spec_files)
end

namespace :spec do
  task :lib do
    sh "bacon #{Dir.glob("spec/lib/**/*_spec.rb").join(' ')}"
  end

  task :motion => 'spec'

  task :all => [:lib, :motion]
end

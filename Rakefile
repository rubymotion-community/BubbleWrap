require "bundler/gem_tasks"
$:.unshift("/Library/RubyMotion/lib")
if ENV['osx']
  require 'motion/project/template/osx'
else
  require 'motion/project/template/ios'
end
Bundler.setup
Bundler.require

require 'bubble-wrap/all'
require 'bubble-wrap/test'
require 'webstub'

module Motion
  module Project
    class Config
      def spec_files=(spec_files)
        @spec_files = spec_files
      end
    end
  end
end

Motion::Project::App.setup do |app|
  app.name = 'testSuite'
  app.identifier = 'io.bubblewrap.testSuite'
  app.specs_dir = './spec/motion'
  app.spec_files
  if Motion::Project::App.osx?
    app.spec_files -= Dir.glob("./spec/motion/**/ios/**.rb")
    ["font", "motion", "location", "media", "ui", "mail", "sms", "network-indicator"].each do |package|
      app.spec_files -= Dir.glob("./spec/motion/#{package}/**/*.rb")
    end
  else
    app.spec_files -= Dir.glob("./spec/motion/**/osx/**.rb")
  end
  app.version = '1.2.3'
end

namespace :spec do
  task :lib do
    sh "bacon #{Dir.glob("spec/lib/**/*_spec.rb").join(' ')}"
  end

  task :motion => 'spec'

  task :all => [:lib, :motion]
end

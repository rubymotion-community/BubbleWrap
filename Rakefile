require "bundler/gem_tasks"
$:.unshift("/Library/RubyMotion/lib")
case ENV['BW_PLATFORM']
  when 'osx'
    require 'motion/project/template/osx'
  when 'tvos'
    require 'motion/project/template/tvos'
  else
    require 'motion/project/template/ios'
end

Bundler.setup
Bundler.require

require 'bubble-wrap/all' unless ENV['BW_PLATFORM'] == 'tvos'
require 'bubble-wrap/tv' if ENV['BW_PLATFORM'] == 'tvos'
require 'bubble-wrap/test'

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
  case
  when Motion::Project::App.osx?
    app.spec_files -= Dir.glob("./spec/motion/**/ios/**.rb")
    %w(font motion location media ui mail sms network-indicator).each do |package|
      app.spec_files -= Dir.glob("./spec/motion/#{package}/**/*.rb")
    end
  when Motion::Project::App.tvos?
    app.deployment_target = '10.2'
    app.info_plist['NSLocationAlwaysUsageDescription'] = 'Description'
    app.info_plist['NSLocationWhenInUseUsageDescription'] = 'Description'
    app.spec_files -= Dir.glob("./spec/motion/**/osx/**.rb")
    %w(mail sms).each do |package|
      app.spec_files -= Dir.glob("./spec/motion/#{package}/**/*.rb")
    end
  else
    app.deployment_target = '11.3'
    app.info_plist['NSLocationAlwaysUsageDescription'] = 'Description'
    app.info_plist['NSLocationWhenInUseUsageDescription'] = 'Description'

    app.spec_files -= Dir.glob("./spec/motion/**/osx/**.rb")
  end

  app.version       = '1.2.3'
  app.short_version = '3.2.1'
end

namespace :spec do
  task :lib do
    sh "bacon #{Dir.glob("spec/lib/**/*_spec.rb").join(' ')}"
  end

  task :motion => 'spec'

  task :all => [:lib, :motion]
end

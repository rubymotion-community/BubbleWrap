$:.unshift("/Library/RubyMotion/lib")
$:.unshift("~/.rubymotion/rubymotion-templates")
require 'motion/project/template/gem/gem_tasks'
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

require 'bubble-wrap/all'
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
    app.info_plist['NSLocationAlwaysUsageDescription'] = 'Description'
    app.info_plist['NSLocationWhenInUseUsageDescription'] = 'Description'
    app.spec_files -= Dir.glob("./spec/motion/**/osx/**.rb")
    %w(font mail media motion sms ui).each do |package|
      app.spec_files -= Dir.glob("./spec/motion/#{package}/**/*.rb")
    end
    %w(ios osx).each do |platform|
      app.spec_files -= Dir.glob("./spec/motion/**/#{platform}/**.rb")
    end
  else
    app.info_plist['NSCameraUsageDescription'] = 'Description'
    app.info_plist['NSPhotoLibraryUsageDescription'] = 'Description'
    app.info_plist['NSLocationAlwaysUsageDescription'] = 'Description'
    app.info_plist['NSLocationWhenInUseUsageDescription'] = 'Description'

    %w(osx tvos).each do |platform|
      app.spec_files -= Dir.glob("./spec/motion/**/#{platform}/**.rb")
    end
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

unless defined?(Motion::Project::Config)
  raise 'This file must be required within a RubyMotion project Rakefile.'
end

unless defined?(BubbleWrap::LOADER_PRESENT)
  require 'bubble-wrap/version' unless defined?(VERSION)
  if Gem::Version.new(Motion::Version) < Gem::Version.new(BubbleWrap::MIN_MOTION_VERSION)
    raise "BubbleWrap #{BubbleWrap::VERSION} requires at least RubyMotion #{BubbleWrap::MIN_MOTION_VERSION}"
  end

  require 'bubble-wrap/ext'
  require 'bubble-wrap/requirement'

  module BubbleWrap

    LOADER_PRESENT = true
    module_function

    def root
      File.expand_path('../../../', __FILE__)
    end

    def require(file_spec, &block)
      Requirement.scan(caller.first, file_spec, &block)
    end

    def require_ios(requirement = nil, &callback)
      if !Motion::Project::App.osx?
        callback.call
      else
        puts "bubble-wrap/#{requirement} requires iOS to use." if requirement
      end
    end

    def require_osx(requirement = nil, &callback)
      if Motion::Project::App.osx?
        callback.call
      else
        puts "bubble-wrap/#{requirement} requires OS X to use." if requirement
      end
    end

    def before_config(app)
      app.files = ::BubbleWrap::Requirement.files(app.files)
      app.files_dependencies ::BubbleWrap::Requirement.files_dependencies
      app.frameworks = ::BubbleWrap::Requirement.frameworks(app.frameworks)
    end

    def after_config(config)
      return unless ::BubbleWrap::Requirement.frameworks.include?("CoreLocation")
      BubbleWrap.require_ios do
        ios8_files = 'motion/ios/8/location_constants.rb'
        if config.send(:deployment_target).to_f >= 8.0
          ::BubbleWrap.require(ios8_files)
          before_config(config)
        else
          config.files = config.files.reject {|s|
            s.include?(ios8_files)
          }
        end
      end
    end
  end

  BW = BubbleWrap unless defined?(BW)

  BW.require 'motion/shortcut.rb'
  BW.require 'lib/bubble-wrap/version.rb'
  BW.require 'motion/util/deprecated.rb'

end

module BubbleWrap
  module Ext
    module BuildTask

      def self.extended(base)
        base.instance_eval do
          def setup_with_bubblewrap(*args, &block)
            bw_config = proc do |app|
              ::BubbleWrap.before_config(app)
              block.call(app) unless block.nil?
            end

            setup_without_bubblewrap *args, &bw_config
          end
          alias :setup_without_bubblewrap :setup
          alias :setup :setup_with_bubblewrap
        end
      end

    end

    module Config
      def self.extended(base)
        base.instance_eval do
          def config_with_bubblewrap
            config_without_bubblewrap.tap do |c|

            end
          end
          alias :config_without_bubblewrap :config
          alias :config :config_with_bubblewrap
        end
      end
    end

    module Platforms
      def osx?
        self.respond_to?(:template) && self.template == :osx
      end
    end
  end
end

Motion::Project::App.extend(BubbleWrap::Ext::BuildTask)

Motion::Project::App.extend(BubbleWrap::Ext::Platforms)

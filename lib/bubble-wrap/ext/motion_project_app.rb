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
      def config_with_bubblewrap
        config_without_bubblewrap.tap do |c|
          ::BubbleWrap.after_config(c)
        end
      end

      def self.extended(base)
        singleton_class = class << base; self; end
        singleton_class.send :alias_method, :config_without_bubblewrap, :config
        singleton_class.send :alias_method, :config, :config_with_bubblewrap
      end
    end

    module Platforms
      def osx?
        self.respond_to?(:template) && self.template == :osx
      end
      def tvos?
        self.respond_to?(:template) && self.template == :tvos
      end
    end
  end
end

Motion::Project::App.extend(BubbleWrap::Ext::BuildTask)

Motion::Project::App.extend(BubbleWrap::Ext::Platforms)

Motion::Project::App.extend(BubbleWrap::Ext::Config)

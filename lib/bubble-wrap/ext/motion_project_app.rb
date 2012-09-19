module BubbleWrap
  module Ext
    module BuildTask

      def self.extended(base)
        base.instance_eval do
          def setup_with_bubblewrap(&block)
            bw_config = proc do |app|
              app.files = ::BubbleWrap::Requirement.files(app.files)
              app.files_dependencies ::BubbleWrap::Requirement.files_dependencies
              app.frameworks = ::BubbleWrap::Requirement.frameworks(app.frameworks)
              block.call(app) unless block.nil?
            end
            config.setup_blocks << bw_config
          end
          alias :setup_without_bubblewrap :setup
          alias :setup :setup_with_bubblewrap
        end
      end

    end
  end
end

Motion::Project::App.extend(BubbleWrap::Ext::BuildTask)

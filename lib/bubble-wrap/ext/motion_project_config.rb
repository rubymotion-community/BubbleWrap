module BubbleWrap
  module Ext
    module ConfigTask

      def self.included(base) 
        base.class_eval do
          alias_method :files_dependencies_without_bubblewrap, :files_dependencies
          alias_method :files_dependencies, :files_dependencies_with_bubblewrap
        end
      end

      def path_matching_expression
        /^\.?\//
      end

      def files_dependencies_with_bubblewrap(deps_hash)
        res_path = lambda do |x|
          path = path_matching_expression.match(x) ? x : File.join('.', x)
          unless @files.include?(path)
            Motion::Project::App.send(:fail, "Can't resolve dependency `#{x}' because #{path} is not in #{@files.inspect}")
          end
          path
        end
        deps_hash.each do |path, deps|
          deps = [deps] unless deps.is_a?(Array)
          @dependencies[res_path.call(path)] = deps.map(&res_path)
        end
      end

    end
  end
end

Motion::Project::Config.send(:include, BubbleWrap::Ext::ConfigTask)

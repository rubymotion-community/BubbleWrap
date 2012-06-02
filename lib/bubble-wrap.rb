require "bubble-wrap/version"

unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

module Motion
  module Project
    class Config
      # HACK NEEDED since RubyMotion doesn't support full path
      # dependencies.
      def files_dependencies(deps_hash)
        res_path = lambda do |x|
          path = /^\.|\/Users\/|\/Library\//.match(x) ? x : File.join('.', x)
          unless @files.include?(path)
            App.fail "Can't resolve dependency `#{x}' because #{path} is not in #{@files.inspect}"
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


Motion::Project::App.setup do |app|
  wrapper_files = []
  Dir.glob(File.join(File.dirname(__FILE__), 'bubble-wrap/**/*.rb')).each do |file|
    app.files << file
    wrapper_files << file
  end
  pollution_file = File.expand_path(File.join(File.dirname(__FILE__), 'pollute.rb'))
  app.files.unshift pollution_file
  app.files_dependencies pollution_file => wrapper_files
end

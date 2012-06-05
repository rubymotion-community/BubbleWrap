module Motion
  module Project
    class Config
      # HACK NEEDED since RubyMotion doesn't support full path
      # dependencies.
      def files_dependencies(deps_hash)
        res_path = lambda do |x|
          path = /^\.?\//.match(x) ? x : File.join('.', x)
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

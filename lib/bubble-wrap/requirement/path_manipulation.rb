module BubbleWrap
  class Requirement
    module PathManipulation

      def convert_caller_to_root_path(path)
        path = convert_caller_to_path path
        path = convert_to_absolute_path path
        strip_up_to_last_lib path
      end

      def convert_caller_to_path(string)
        chunks = string.split(':')
        if chunks.size >= 3
          string = chunks[0..-3].join(':')
          string = File.dirname(string)
        end
        string
      end

      def convert_to_absolute_path(path)
        File.expand_path(path)
      end

      def strip_up_to_last_lib(path)
        if path =~ /\/lib$/
          path = path.gsub(/\/lib$/, "")
        else
          path = path.split('lib')
          path = if path.size > 1
                   path[0..-2].join('lib')
                 else
                   path[0]
                 end
          path = path[0..-2] if path[-1] == '/'
        end
        path
      end

      def convert_to_relative(path,root)
        path = path.gsub(root,'')
        path = path[1..-1] if path[0] == '/'
        path
      end

    end
  end
end

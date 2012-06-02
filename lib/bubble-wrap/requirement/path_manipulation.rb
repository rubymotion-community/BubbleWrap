module BubbleWrap
  class Requirement
    module PathManipulation

      def convert_caller_to_root_path(path)
        path = convert_caller_to_path path
        path = convert_to_absolute_path path
        strip_up_to_last_lib path
      end

      def convert_caller_to_path(caller_string)
        caller_string.split(':')[0..-3].join(':')
      end

      def convert_to_absolute_path(path)
        path = File.expand_path(path) unless path[0] == '/'
        path
      end

      def strip_up_to_last_lib(path)
        path = path.split('lib')
        if path.size > 1
          path[0..-2].join('lib')
        else
          path[0]
        end
      end

      def convert_to_relative(path,root)
        path.gsub(root,'')
      end

    end
  end
end

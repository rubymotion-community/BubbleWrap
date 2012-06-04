require File.expand_path "../requirement/path_manipulation", __FILE__

module BubbleWrap
  class Requirement
    extend PathManipulation
    include PathManipulation

    attr_accessor :file, :root, :file_dependencies, :frameworks

    def initialize(file,root)
      self.file = file
      self.root = root
      self.file_dependencies = []
      self.frameworks = []
    end

    def relative
      convert_to_relative(file, root)
    end

    def depends_on(file_or_paths)
      paths = file_or_paths.respond_to?(:each) ? file_or_paths : [ file_or_paths ]
      self.file_dependencies += paths.map do |f|
        if f.is_a? Requirement
          f unless f.file == file
        else
          self.class.file(f)
        end
      end.compact
    end

    def uses_framework(framework_name)
      self.frameworks << framework_name
    end

    def dependencies
      return {} if file_dependencies.empty?
      { file => file_dependencies.map(&:to_s) }
    end

    def to_s
      file
    end

    class << self

      attr_accessor :paths, :bw_file

      def scan(caller_location, file_spec, block=nil)
        root = convert_caller_to_root_path caller_location
        self.paths ||= {}
        Dir.glob(File.expand_path(file_spec, root)).each do |file|
          p = new(file,root)
          p.depends_on bw_file
          self.paths[p.relative] = p
        end
        class_eval(&block) if block.respond_to?(:call)
      end

      def file(relative)
        paths.fetch(relative)
      end

      def files
        paths.values.map(&:to_s)
      end

      def files_dependencies
        deps = {}
        paths.each_value do |file|
          deps.merge! file.dependencies
        end
        deps
      end

      def frameworks
        frameworks = ['UIKit', 'Foundation', 'CoreGraphics'] +
          paths.values.map(&:frameworks)
        frameworks.flatten.compact.sort.uniq
      end

      def bw_file
        @bw_file ||= new(File.join(::BubbleWrap.root,'app/bubble-wrap.rb'), ::BubbleWrap.root)
      end

    end
  end
end

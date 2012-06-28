require 'bubble-wrap/requirement/path_manipulation'

module BubbleWrap
  class Requirement
    extend PathManipulation
    include PathManipulation

    attr_accessor :file, :root
    attr_writer :file_dependencies

    def initialize(file,root)
      self.file = file
      self.root = root
    end

    def relative
      convert_to_relative(file, root)
    end

    def depends_on(file_or_paths)
      paths = file_or_paths.respond_to?(:each) ? file_or_paths : [ file_or_paths ]
      self.file_dependencies += paths.map do |f|
        f = self.class.file(f) unless f.is_a? Requirement
        f unless f.file == file
      end.compact
      self.file_dependencies.uniq!(&:to_s)
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

    def file_dependencies
      @file_dependencies ||= []
    end

    def frameworks
      @frameworks ||= []
    end

    class << self

      attr_accessor :paths

      def scan(caller_location, file_spec, &block)
        root = convert_caller_to_root_path caller_location
        self.paths ||= {}
        Dir.glob(File.expand_path(file_spec, root)).each do |file|
          p = new(file,root)
          self.paths[p.relative] = p
          p.depends_on('motion/shortcut.rb') unless p.relative == 'motion/shortcut.rb'
        end
        self.class_eval(&block) if block
      end

      def file(relative)
        paths.fetch(relative)
      end

      def files(app_files=nil)
        files = paths.values.map(&:to_s)
        files += app_files if app_files
        files.uniq
      end

      def clear!
        paths.select! { |k,v| v.relative == 'motion/shortcut.rb' }
      end

      def files_dependencies
        deps = {}
        paths.each_value do |file|
          deps.merge! file.dependencies
        end
        deps
      end

      def frameworks(app_frameworks=nil)
        frameworks = ['UIKit', 'Foundation', 'CoreGraphics'] +
          paths.values.map(&:frameworks)
        frameworks += app_frameworks if app_frameworks
        frameworks.flatten.compact.sort.uniq
      end

    end
  end
end

# Create a fake Motion class hierarchy for testing.
module Motion
  module Project
    class App
      def self.setup
      end
    end
    
    class Config
      def files_dependencies
      end
    end
  end
  Version = "1.24"
end

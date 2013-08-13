module BubbleWrap
  module Message
    class Result
      attr_accessor :result

      def initialize(result)
        self.result = result
      end

      def sent?
        self.result == MFMailComposeResultSent
      end

      def canceled?
        self.result == MFMailComposeResultCancelled
      end

      def failed?
        self.result == MFMailComposeResultFailed
      end
      
    end
  end
end

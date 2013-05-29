module BubbleWrap
  module Mail
    class Result
      attr_accessor :result, :error

      def initialize(result, error)
        self.result = result
        self.error = error
      end

      def sent?
        self.result == MFMailComposeResultSent
      end

      def canceled?
        self.result == MFMailComposeResultCancelled
      end

      def saved?
        self.result == MFMailComposeResultSaved
      end

      def failed?
        self.result == MFMailComposeResultFailed || self.error
      end
      
    end
  end
end

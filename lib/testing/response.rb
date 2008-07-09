module Mack
  module Testing
    class Response
      
      attr_accessor :responses
      
      def initialize(responses)
        self.responses = [responses].flatten
      end
      
      def method_missing(sym, *args)
        self.responses.last.send(sym, *args)
      end
      
      def successful?
        self.responses.first.successful?
      end
      
      def redirect?
        self.responses.first.redirect?
      end
      
      def not_found?
        self.responses.first.not_found?
      end
      
      def server_error?
        self.responses.first.server_error?
      end
      
      def status
        self.responses.first.status
      end
      
      def redirected_to?(loc)
        self.responses.first.location == loc
      end
      
    end # Response
  end # Testing
end # Mack
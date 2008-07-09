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
      
    end # Response
  end # Testing
end # Mack
module Mack
  module Utils
    #
    # The whole purpose of this handler is to intercept the rack application process, 
    # calculate the size of the response body, and set the 'Content-Length' header if necessary.
    #
    # From: http://thin.lighthouseapp.com/projects/7212/tickets/74
    # Content-Length should not be automatically added:
    # * When the Status code is 1xx, 204 or 304
    # * When the Transfer-Encoding header is set to chunked
    # * When the body is neither a String or an Array
    #
    class ContentLengthHandler
      attr_reader :response
      
      def initialize(app) # :nodoc:
        @app = app
      end

      def call(env) # :nodoc:
        ret = @app.call(env)
                
        status        = ret[0]
        hdr           = ret[1]
        @response     = ret[2]
           
        unless self.response.is_a?(Rack::File) or 
               (!self.response.body.kind_of?Array and !self.response.body.kind_of?String) or 
               hdr["Transfer-Encoding"] == "chunked" or
               (status == 204 or status == 304 or (status >= 100 and status < 200))
          size = 0
          
          if self.response.body.respond_to?(:to_str)
            size = self.response.body.to_str.size
          elsif self.response.body.respond_to?(:each)
            self.response.body.each { |part| size += part.to_s.size }
          end
          
          hdr["Content-Length"] = size.to_s
        end
        return ret
      end
    end
  end
end
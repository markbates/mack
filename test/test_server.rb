require 'singleton'
require 'mongrel'

module Mack
  module Testing
    class Server
      include Singleton
      
      attr_reader :mongrel_instance

      def initialize
        begin
          puts app_config.mack.default_domain_port
          @mongrel_instance = Mongrel::HttpServer.new("0.0.0.0", app_config.mack.default_domain_port)
          @mongrel_instance.register("/", Mack::Testing::DynamicHandler.new)
          # @mongrel_instance.register("/files", Mongrel::DirHandler.new("."))
          Thread.new do
            @mongrel_instance.run.join
          end
        rescue Exception => e
          puts e
        end
      end
      
      def register(uri, method = :get, status = 200, &block)

      end
      
      
    end # Server
    
    class DynamicHandler < Mongrel::HttpHandler
      
      def process(request, response)
        response.start(200) do |head,out|
          pp request
          pp response
          pp head
          head["Content-Type"] = "text/plain"
          out.write("hello!\n")
        end
      end
      
    end # DynamicHandlerHandler
    
  end # Test
end # Mack
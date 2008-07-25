module Mack
  # Even though it's called, SimpleServer, this might be the only server you need to run
  # a Mack application.
  # 
  # This SimpleServer does not use Thin. But does work with anything that Rack has a handler for.
  class SimpleServer
    
    class << self
      
      def run(options)
        r = "Rack::Handler::#{options.handler.camelcase}"
        puts "Starting app using: #{r} in #{options.environment} mode on port: #{options.port}"
        eval(r).run(Mack::Utils::Server.build_app, :Port => options.port)
      end
      
    end
    
  end
end
require File.join(File.dirname(__FILE__), 'routing', 'urls')
require File.join(File.dirname(__FILE__), 'application')
module Mack
  class Runner # :nodoc:

    def call(env) # :nodoc:
      Mack::Application.new.call(env)
    end
    
    def deferred?(env) # :nodoc:
      if configatron.mack.use_deferred_routes
        method = env["REQUEST_METHOD"].downcase.to_sym
        routes = Mack::Routes.deferred_routes_list[method]
        routes.each do |route|
          return true if route.match?(:uri => env['PATH_INFO'], :host => env['SERVER_NAME'], :port => env['SERVER_PORT'], :scheme => env['rack.url_scheme'])
        end
      end
      return false
    end
    
  end # Runner
end # Mack
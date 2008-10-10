module Mack
  class Static < Rack::Static # :nodoc:
    
    def call(env)
      path = env["PATH_INFO"]
      can_serve = @urls.any? { |url| path.index(url) == 0 }

      if can_serve
        res = @file_server.call(env)
        # This is the BIG difference between Mack::Static and Rack::Static:
        return @app.call(env) if res.nil? || res[0] == 404
        return res
      else
        return @app.call(env)
      end
    end
    
  end # Static
end # Mack
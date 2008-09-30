module Mack
  class HandleExceptions
    
    def initialize(app)
      @app = app
    end
    
    def call(env)
      begin
        return @app.call(env)
      rescue Mack::Errors::ResourceNotFound, Mack::Errors::UndefinedRoute => ex
        return handle_error(404, 'Page Not Found!')
      rescue Exception => e
        return handle_error(500, 'Server Error!')
      end
    end
    
    private
    def handle_error(status, body)
      response = Mack::Response.new
      response.status = status
      if File.exists?(Mack::Paths.public("#{status}.html"))
        body = File.read(Mack::Paths.public("#{status}.html"))
      end
      response.write(body)
      return response.finish
    end
    
  end
end
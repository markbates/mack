module Mack
  # Right now Mack::Response is just a wrapper around Rack::Response.
  # Down the line this may be used to spice up the response.
  class Response < Rack::Response
    
    attr_accessor :controller
    
    def assigns(key)
      self.controller.instance_variable_get("@#{key}")
    end
    
    def attachment=(file_name)
      self['Content-Disposition'] = "attachment; filename=#{file_name}"
    end
    
  end
end
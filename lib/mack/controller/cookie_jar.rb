module Mack
  
  # Examples:
  #   class MyAwesomeController
  #     include Mack::Controller
  #     def index
  #       cookies[:id] = 1
  #       render(:text,  "Hello!")
  #     end
  # 
  #     def show
  #       render(:text,  "The id in the cookie is: #{cookies[:id]}")
  #     end
  #   end
  class CookieJar
    
    attr_reader :all_cookies # :nodoc:
    attr_reader :request # :nodoc:
    attr_reader :response # :nodoc:
    
    def initialize(request, response) # :nodoc:
      @request = request
      @response = response
      @all_cookies = request.cookies
    end
    
    # Returns the value of a cookie as a String, or nil it doesn't exist.
    # This will check both the incoming cookies on the request, as well as
    # any cookies that have been set as part of the current action.
    def [](key)
      return nil if key.nil?
      # check both the incoming cookies and the outgoing cookies to see if 
      # the cookie we're looking for exists.
      c = (self.all_cookies[key.to_s] || self.all_cookies[key.to_sym])
      return c if c.is_a?(String)
      return c[:value] if c.is_a?(Hash)
      return nil
    end
    
    # Set a cookie with a specified value.
    def []=(key, value)
      key = key.to_s
      unless value.is_a?(Hash)
        value = {:value => value}
      end
      value = app_config.mack.cookie_values.symbolize_keys.merge(value)
      self.all_cookies[key] = value
      self.response.set_cookie(key, value)
    end
    
    # Deletes a cookie.
    def delete(key)
      key = key.to_s
      self.all_cookies.delete(key)
      self.response.delete_cookie(key)
    end
    
    # Returns both cookies that came in as part of the request, as well as those set
    # on to the response. This is useful when you set a cookie in a filter or an action
    # and want to access it in another filter or action before the request/response has
    # been fully completed.
    def all
      self.all_cookies
    end
    
  end # CookieJar
  
end # Mack

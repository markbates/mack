require File.join(File.dirname(__FILE__), "session_store_base")
module Mack
  module SessionStore
    class Cookie < Mack::SessionStore::Base
      
      class << self
    
        def get(id, request, response, cookies)
          raise NoMethodError.new("get")
        end
        
        def set(id, request, response, cookies)
          raise NoMethodError.new("set")
        end
        
        def expire(id, request, response, cookies)
          raise NoMethodError.new("expire")
        end
        
        def expire_all(request, response, cookies)
          raise NoMethodError.new("expire_all")
        end
      
      end
      
    end
  end
end
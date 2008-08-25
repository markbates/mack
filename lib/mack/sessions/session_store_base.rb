module Mack
  module SessionStore
    
    def self.store
      ivar_cache do
        "Mack::SessionStore::#{app_config.mack.session_store.camelcase}".constantize
      end
    end
    
    class Base

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
      
    end # Base
  end # SessionStore
end # Mack
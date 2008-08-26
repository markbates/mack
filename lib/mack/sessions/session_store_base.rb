module Mack
  module SessionStore
    
    class << self
      
      def store # :nodoc:
        ivar_cache do
          "Mack::SessionStore::#{app_config.mack.session_store.camelcase}".constantize
        end
      end
      
      def get(*args)
        self.store.get(*args)
      end
      
      def set(*args)
        self.store.set(*args)
      end
      
      def expire(*args)
        self.store.expire(*args)
      end
      
      def expire_all(*args)
        self.store.expire_all(*args)
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
module Mack
  module SessionStore
    
    class << self
      
      def store # :nodoc:
        ivar_cache do
          "Mack::SessionStore::#{app_config.mack.session_store.camelcase}".constantize
        end
      end
      
      # Calls the get method on the specified session store.
      def get(*args)
        self.store.get(*args)
      end
      
      # Calls the set method on the specified session store.
      def set(*args)
        self.store.set(*args)
      end
      
      # Calls the expire method on the specified session store.
      def expire(*args)
        self.store.expire(*args)
      end
      
      # Calls the expire_all method on the specified session store.
      def expire_all(*args)
        self.store.expire_all(*args)
      end
      
    end
    
    class Base

      class << self
    
        # Needs to be defined by the subclass. Raises NoMethodError.
        def get(id, request, response, cookies)
          raise NoMethodError.new("get")
        end
        
        # Needs to be defined by the subclass. Raises NoMethodError.
        def set(id, request, response, cookies)
          raise NoMethodError.new("set")
        end
        
        # Needs to be defined by the subclass. Raises NoMethodError.
        def expire(id, request, response, cookies)
          raise NoMethodError.new("expire")
        end
        
        # Needs to be defined by the subclass. Raises NoMethodError.
        def expire_all(request, response, cookies)
          raise NoMethodError.new("expire_all")
        end
      
      end
      
    end # Base
  end # SessionStore
end # Mack
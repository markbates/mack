require File.join(File.dirname(__FILE__), "session_store_base")
module Mack
  module SessionStore
    class Test < Mack::SessionStore::Base

      class << self
        
        def get(id, *args)
          store[id]
        end
        
        def set(id, request, *args)
          store[id] = request.session
        end
        
        def direct_set(id, session)
          store[id] = session
        end
        
        def expire(id, *args)
          store.delete(id)
        end
        
        def expire_all
          @store = {}
        end
        
        private
        def store
          @store ||= {}
        end
        
      end
      
    end # Test
  end # SessionStore
end # Mack
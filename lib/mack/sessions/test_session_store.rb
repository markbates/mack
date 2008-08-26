require File.join(File.dirname(__FILE__), "session_store_base")
module Mack
  module SessionStore
    # A simple Hash based session store for testing.
    class Test < Mack::SessionStore::Base

      class << self
        
        def get(id, *args) # :nodoc:
          store[id]
        end
        
        def set(id, request, *args) # :nodoc:
          store[id] = request.session
        end
        
        def direct_set(id, session) # :nodoc:
          store[id] = session
        end
        
        def expire(id, *args) # :nodoc:
          store.delete(id)
        end
        
        def expire_all # :nodoc:
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
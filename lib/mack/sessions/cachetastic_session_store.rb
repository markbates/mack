require File.join(File.dirname(__FILE__), "session_store_base")
module Mack
  module SessionStore
    class Cachetastic < Mack::SessionStore::Base
      
      class << self
        
        def get(id, request, response, cookies)
          ::Cachetastic::Caches::MackSessionCache.get(id)
        end
        
        def set(id, request, response, cookies)
          ::Cachetastic::Caches::MackSessionCache.set(id, request.session)
        end
        
        def expire(id)
          ::Cachetastic::Caches::MackSessionCache.delete(id)
        end
        
        def expire_all
          ::Cachetastic::Caches::MackSessionCache.expire_all
        end
        
      end
      
    end
  end
end
require File.join(File.dirname(__FILE__), "session_store_base")
module Mack
  module SessionStore
    class Cookie < Mack::SessionStore::Base
      
      class << self
    
        def get(id, request, response, cookies)
          c = cookies[id]
          return nil if c.nil?
          sess = YAML.load(c.decrypt)
          puts "sess: #{sess.inspect}"
          return sess
        end
        
        def set(id, request, response, cookies)
          cookies[id] = {:value => YAML.dump(request.session).encrypt, :expires => (Time.now + app_config.cookie_session_store.expiry_time)}
        end
        
        def expire(id, request, response, cookies)
          cookies.delete(id)
        end
        
        def expire_all(request, response, cookies)
          raise NoMethodError.new("expire_all")
        end
      
      end
      
    end
  end
end
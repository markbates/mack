require File.join(File.dirname(__FILE__), "session_store_base")
module Mack
  module SessionStore
    # Stores session information in the user's cookie.
    # The session information is encrypted using the mack-encryption library.
    # This is the default session store for Mack applications.
    # To set the expiry time for this session store use the following app_config setting:
    #   cookie_session_store::expiry_time: <%= 4.hours %>
    # It is recommend that you set the app_config setting 'default_secret_key' to
    # something, otherwise it will generate a random one each time you start your application,
    # which could make decrypting cookies a bit of a pain. :)
    class Cookie < Mack::SessionStore::Base
      
      class << self
        
        # Returns a decrypted session from the cookie or nil.
        def get(id, request, response, cookies)
          c = cookies[id]
          return nil if c.nil?
          sess = YAML.load(c.decrypt)
          return sess
        end
        
        # Encrypts the session and places it into the cookie.
        def set(id, request, response, cookies)
          cookies[id] = {:value => YAML.dump(request.session).encrypt, :expires => (Time.now + app_config.cookie_session_store.expiry_time)}
        end
        
        # Deletes the cookie.
        def expire(id, request, response, cookies)
          cookies.delete(id)
        end
      
      end
      
    end
  end
end
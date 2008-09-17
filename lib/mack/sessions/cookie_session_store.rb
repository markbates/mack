require File.join(File.dirname(__FILE__), "session_store_base")
module Mack
  module SessionStore
    # Stores session information in the user's cookie.
    # The session information is encrypted using the mack-encryption library.
    # This is the default session store for Mack applications.
    # To set the expiry time for this session store use the following configatron setting:
    #   cookie_session_store::expiry_time: <%= 4.hours %>
    # It is recommend that you set the configatron setting 'default_secret_key' to
    # something, otherwise it will generate a random one each time you start your application,
    # which could make decrypting cookies a bit of a pain. :)
    class Cookie < Mack::SessionStore::Base
      
      class << self
        
        # Returns a decrypted session from the cookie or nil.
        def get(id, request, response, cookies)
          c = cookies[id]
          return nil if c.nil?
          begin
            sess = YAML.load(c.decrypt)
            return sess
          rescue Exception => e
            # The cookie was bad, delete it and start a new session.
            c.delete(id)
            return nil
          end
        end
        
        # Encrypts the session and places it into the cookie.
        def set(id, request, response, cookies)
          cookies[id] = {:value => YAML.dump(request.session).encrypt, :expires => (Time.now + configatron.cookie_session_store.expiry_time)}
        end
        
        # Deletes the cookie.
        def expire(id, request, response, cookies)
          cookies.delete(id)
        end
      
      end
      
    end
  end
end
module Mack
  module Utils # :nodoc:
    module Crypt # :nodoc:
      # The default worker is one that is used when no other worker is specified or the 
      # specified worker does not exist. It uses the Crypt::Rijndael library and get's 
      # it's secret key from app_config.default_secret_key
      class DefaultWorker
        
        def initialize
          @aes_key = ::Crypt::Rijndael.new(app_config.default_secret_key || (String.randomize(40)))
        end
        
        # Encrypts a string using the Crypt::Rijndael library and the secret key found in
        # app_config.default_secret_key
        def encrypt(x)
          @aes_key.encrypt_string(x)
        end
        
        # Decrypts a string using the Crypt::Rijndael library and the secret key found in
        # app_config.default_secret_key
        def decrypt(x)
          @aes_key.decrypt_string(x)
        end
        
      end # DefaultWorker
    end # Crypt
  end # Utils
end # Mack
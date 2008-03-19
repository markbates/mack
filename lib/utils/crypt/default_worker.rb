module Mack
  module Utils
    module Crypt
      class DefaultWorker
        
        def initialize
          @aes_key = ::Crypt::Rijndael.new('My secret key')
        end
        
        def encrypt(x)
          @aes_key.encrypt_string(x)
        end
        
        def decrypt(x)
          @aes_key.decrypt_string(x)
        end
        
      end # DefaultWorker
    end # Crypt
  end # Utils
end # Mack
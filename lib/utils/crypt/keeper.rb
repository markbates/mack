module Mack
  module Utils
    module Crypt
      # A singleton class that holds/manages all the workers for the system.
      # 
      # A worker must be defined as Mack::Utils::Crypt::<name>Worker and must
      # define an encrypt(value) method and a decrypt(value) method.
      # 
      # Example:
      #  class Mack::Utils::Crypt::ReverseWorker
      #    def encrypt(x)
      #      x.reverse
      #    end
      #
      #    def decrypt(x)
      #      x.reverse
      #    end
      #  end
      class Keeper
        include Singleton
      
        def initialize
          @crypt_workers_cache = {}
        end
        
        # Returns a worker object to handle the encrytion/decryption.
        # If the specified worker doesn't exist then Mack::Utils::Crypt::DefaultWorker
        # is returned.
        def worker(key = :default)
          worker = @crypt_workers_cache[key.to_sym]
          if worker.nil?
            worker_klass = key.to_s.camelcase + "Worker"
            if Mack::Utils::Crypt.const_defined?(worker_klass)
              worker = "Mack::Utils::Crypt::#{worker_klass}".constantize.new
            else
              worker = Mack::Utils::Crypt::DefaultWorker.new
            end
            @crypt_workers_cache[key.to_sym] = worker
          end
          worker
        end
      
      end # Keeper
    end # Crypt
  end # Utils
end # Mack
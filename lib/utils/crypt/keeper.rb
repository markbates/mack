module Mack
  module Utils
    module Crypt
      class Keeper
        include Singleton
      
        def initialize
          @crypt_workers_cache = {}
        end
        
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
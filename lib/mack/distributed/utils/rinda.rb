module Mack
  module Distributed
    module Utils
      module Rinda
        
        def self.register_or_renew(options = {})
          options = handle_options(options)
          ::DRb.start_service
          begin
            ring_server.take([options[:space], options[:klass_def], nil, nil], options[:timeout])
          rescue Exception => e
            # Mack.logger.error(e)
          end
          register(options)
        end
        
        def self.register(options = {})
          options = handle_options(options)
          ::DRb.start_service
          ring_server.write([options[:space], 
                             options[:klass_def], 
                             options[:object], 
                             options[:description]], 
                            ::Rinda::SimpleRenewer.new)
        end
        
        def self.ring_server
          rs = ::Rinda::RingFinger.primary
          rs
        end
        
        def self.read(options = {})
          options = handle_options(options)
          ring_server.read([options[:space], options[:klass_def], nil, options[:description]], options[:timeout])[2]
        end
        
        private
        def self.handle_options(options = {})
          {:space => :name, :klass_def => nil, :object => nil, :description => nil, :timeout => app_config.mack.drb_timeout}.merge(options)
        end
        
      end
    end
  end
end
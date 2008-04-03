module Mack
  module Distributed
    module Routes
      # A class used to house the Mack::Routes::Url module for distributed applications.
      # Functionally this class does nothing, but since you can't cache a module, a class is needed.
      class Urls
        include DRbUndumped
        
        def initialize(dsd) # :nodoc:
          @dsd = dsd
        end
        
        def put
          Mack::Distributed::Utils::Rinda.register_or_renew(:space => app_config.mack.distributed_app_name.to_sym, 
                                                            :klass_def => :distributed_routes, 
                                                            :object => self)
        end
        
        def run(meth, options)
          self.send(meth, options)
        end
        
        class << self
          
          def get(app_name)
            Mack::Distributed::Utils::Rinda.read(:space => app_name.to_sym, :klass_def => :distributed_routes)
          end
          
        end
        
      end # Urls
      
    end # Routes
  end # Distributed
end # Mack
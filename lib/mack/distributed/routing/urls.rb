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
                                                            :object => self, :timeout => 0)
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

Mack::Routes.after_class_method(:build) do
  if app_config.mack.use_distributed_routes
    raise Mack::Distributed::Errors::ApplicationNameUndefined.new if app_config.mack.distributed_app_name.nil?
    
    d_urls = Mack::Distributed::Routes::Urls.new(app_config.mack.distributed_site_domain)
    d_urls.put
  end
end
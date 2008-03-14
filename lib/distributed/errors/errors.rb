module Mack
  module Distributed # :nodoc:
    module Errors # :nodoc:
      
      # Raised when an unknown distributed application is referenced.
      class UnknownApplication < StandardError
        # Takes the application name.
        def initialize(app_name)
          super("APPLICATION: #{app_name} is not a known/registered distributed application.")
        end
      end
    
      # Raised when an unknown distributed route name for a distributed application is referenced.
      class UnknownRouteName < StandardError
        # Takes the application name and the route name.
        def initialize(app_name, route_name)
          super("ROUTE_NAME: #{route_name}, is not a known/registered distributed route name for application: #{app_name}.")
        end
      end
      
      # Raised when an application doesn't declare it's application name for use in a distributed system.
      class ApplicationNameUndefined < StandardError
      end
      
    end # Errors
  end # Distributed
end # Mack
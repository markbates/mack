module Mack
  module Logging # :nodoc:
    
    # Used to house a list of filters for parameter logging. The initial list
    # includes password and password_confirmation
    class Filter
      include Singleton
    
      # The list of parameters you want filtered for logging.
      attr_reader :list
    
      def initialize
        @list = [:password, :password_confirmation]
      end
    
      # Adds 'n' number of parameter names to the list
      def add(*args)
        @list << args
        @list.flatten!
      end
    
      # Removes 'n' number of parameter names from the list
      def remove(*args)
        @list = (@list - args)
      end
    
      class << self
      
        def remove(*args)
          Mack::Logging::Filter.instance.remove(*args)
        end
      
        def add(*args)
          Mack::Logging::Filter.instance.add(*args)
        end
      
        def list
          Mack::Logging::Filter.instance.list
        end
      
      end
    
    end # Filter
  end # Logging
end # Mack
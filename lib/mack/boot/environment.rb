require 'mack-facets'

run_once do
  
  module Mack
    # Allows hook methods for the loading of the environment.
    module Environment
      include Extlib::Hook

      # Requires the Mack application classes only once.
      # This is the method you want to add 'hooks' on for 
      # application load setup.
      def self.load
        ivar_cache do
          require File.join_from_here("..", "..", "mack_app")
        end
      end

    end
  end
  
end
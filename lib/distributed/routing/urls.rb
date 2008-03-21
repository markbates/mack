module Mack
  module Distributed
    module Routes
      # A class used to house the Mack::Routes::Url module for distributed applications.
      # Functionally this class does nothing, but since you can't cache a module, a class is needed.
      class Urls
        
        def initialize(dsd) # :nodoc:
          @dsd = dsd
        end
        
      end # Urls
    end # Routes
  end # Distributed
end # Mack
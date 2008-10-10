require File.join_from_here('..', 'utils', 'gem_manager.rb')

module Mack
  module Portlet # :nodoc:
    
    # Used to manage the Portlets associated with the application.
    class Manager
      include Singleton

      attr_accessor :required_portlet_list
      
      def initialize # :nodoc:
        @required_portlet_list = []
      end
      
      # Adds a Portlet to the application. This takes the same parameters as
      # Mack::Utils::GemManager.instance.add
      def add(name, options = {})
        @required_portlet_list << name
        @required_portlet_list.uniq!
        Mack::Utils::GemManager.instance.add(name, options)
      end
      
      
    end # Manager
  end # Portlet
end # Mack
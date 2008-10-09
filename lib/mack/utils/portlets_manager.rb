require File.join_from_here('gem_manager.rb')

module Mack
  module Utils

    class PortletsManager
      include Singleton

      attr_accessor :required_portlet_list
      
      def initialize # :nodoc:
        @required_portlet_list = []
      end
      
      def add(name, options = {})
        @required_portlet_list << name
        @required_portlet_list.uniq!
        Mack::Utils::GemManager.instance.add(name, options)
      end
      
      
    end # Manager
  end # Portlets
end # Mack
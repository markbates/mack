module Mack
  module Utils # :nodoc:
    class HttpStatusCodes < Mack::Utils::RegistryMap
      
      def initial_state
        YAML.load(File.read(File.join(File.dirname(__FILE__), 'http_status_codes.yml')))
      end
      
      class << self
        
        def get(status)
          self.registered_items[status.to_i] || 'UNKNOWN HTTP STATUS'
        end
        
      end
      
    end # HttpStatusCodes
  end # Utils
end # Mack
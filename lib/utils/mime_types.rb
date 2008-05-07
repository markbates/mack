module Mack
  module Utils
    class MimeTypes
      include Singleton
      
      def initialize
        @types = YAML.load(File.open(File.join(File.dirname(__FILE__), "mime_types.yml")))
      end
      
      def register(name, type)
        @types[name.to_sym] = type
      end
      
      def get(name)
        @types[name.to_sym] || "text/html"
      end
      
      class << self
        
        def [](name)
          Mack::Utils::MimeTypes.instance.get(name.to_sym)
        end
        
        def register(name, type)
          Mack::Utils::MimeTypes.instance.register(name, type)
        end
        
      end
      
    end # MimeTypes
  end # Utils
end # Mack
module Mack
  module Utils
    class MimeTypes
      include Singleton
      
      def initialize # :nodoc:
        @types = YAML.load(File.open(File.join(File.dirname(__FILE__), "mime_types.yml")))
      end
      
      # Registers a new mime-type to the system.
      # 
      # Examples:
      # Mack::Utils::MimeTypes.register(:iphone, "app/iphone")
      def register(name, type)
        name = name.to_sym
        if @types.has_key?(name)
          @types[name] << "; " << type
        else
          @types[name] = type
        end
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
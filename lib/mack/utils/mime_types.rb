module Mack
  module Utils
    # Houses the MimeTypes used by the system to set the proper 'Content-Type' for requests.
    class MimeTypes
      include Singleton
      
      def initialize # :nodoc:
        @types = YAML.load(File.open(File.join(File.dirname(__FILE__), "mime_types.yml")))
      end
      
      # Registers a new mime-type to the system. If the key already exists, it will
      # be appended to the existing type.
      # 
      # Examples:
      # Mack::Utils::MimeTypes.register(:iphone, "app/iphone")
      #   "/users.iphone" # => will have a 'Content-Type' header of "app/iphone"
      # Mack::Utils::MimeTypes.register(:iphone, "application/mac-iphone")
      #   "/users.iphone" # => will have a 'Content-Type' header of "app/iphone; application/mac-iphone"
      def register(name, type)
        name = name.to_sym
        if @types.has_key?(name)
          @types[name] << "; " << type
        else
          @types[name] = type
        end
      end
      
      # Returns the type registered for the key, if there is no type for the key,
      # then "text/html" is returned
      # 
      # Examples:
      # Mack::Utils::MimeTypes.get(:iphone)
      #   # => "app/iphone"
      # Mack::Utils::MimeTypes.get(:i_dont_exist)
      #   # => "text/html"
      def get(name)
        @types[name.to_sym] || "text/html"
      end
      
      class << self
        
        # Maps to Mack::Utils::MimeTypes.instance.get
        def [](name)
          Mack::Utils::MimeTypes.instance.get(name.to_sym)
        end
        
        # Maps to Mack::Utils::MimeTypes.instance.register
        def register(name, type)
          Mack::Utils::MimeTypes.instance.register(name, type)
        end
        
      end
      
    end # MimeTypes
  end # Utils
end # Mack
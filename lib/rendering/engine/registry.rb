module Mack
  module Rendering
    module Engine
      # A registry used to store which Mack::Rendering::Type objects can use which Mack::Rendering::Engine objects.
      # 
      # Example:
      #   Mack::Rendering::Engine::Registry.register(:bar, :sass)
      #   render(:bar, "my_file") will now get run through Mack::Rendering::Type::Bar and Mack::Rendering::Engine::Sass
      class Registry
        include Singleton
        
        # Returns all the engines registered with the system.
        attr_reader :engines
      
        def initialize
          @engines = {
            :action => [:erubis, :builder],
            :template => [:erubis, :builder],
            :partial => [:erubis, :builder],
            :layout => [:erubis],
            :xml => [:builder]
          }
        end
        
        # Registers an engine to a type.
        # 
        # Example:
        # Mack::Rendering::Engine::Registry.register(:action, :haml)
        def register(type, engine)
          type = type.to_sym
          if self.engines.has_key?(type)
            self.engines[type].insert(0, engine)
          else
            self.engines[type] = [engine]
          end
        end
      
        class << self
        
          def method_missing(sym, *args)
            Mack::Rendering::Engine::Registry.instance.send(sym, *args)
          end
        
        end
      end # Registry
    end # Engines
  end # Rendering
end # Mack
module Mack
  module Rendering
    module Engine
      class Registry
        include Singleton
      
        attr_reader :engines
      
        def initialize
          @engines = {
            :action => [:erubis],
            :partial => [:erubis],
            :layout => [:erubis],
            :xml => [:builder]
          }
        end
      
        def register(type, options = {})
          type = type.to_sym
          if self.engines.has_key?(type)
            self.engines[type].insert(0, options)
          else
            self.engines[type] = [options]
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
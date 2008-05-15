module Mack
  module Rendering
    module Engine
      class Erubis < Mack::Rendering::Engine::Base
        
        def render(io, binding)
          ::Erubis::Eruby.new(io).result(binding)
        end
        
        def extension
          :erb
        end
        
        def concat(txt, b)
          eval( "_buf", b) << txt
        end
        
      end # ErubisInMemory
    end # Engines
  end # Rendering
end # Mack
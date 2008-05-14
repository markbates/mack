module Mack
  module Rendering
    module Engine
      class Erubis < Base
        
        def render(io, binding)
          ::Erubis::Eruby.new(io).result(binding)
        end
        
        def extension
          :erb
        end
        
      end # ErubisInMemory
    end # Engines
  end # Rendering
end # Mack
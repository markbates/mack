module Mack
  module Rendering # :nodoc:
    module Engine # :nodoc:
      # Allows use of the Builder::XmlMarkup engine to be used with rendering.
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
        
      end # Erubis
    end # Engines
  end # Rendering
end # Mack
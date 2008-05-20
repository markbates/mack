module Mack
  module Rendering # :nodoc:
    module Engine # :nodoc:
      # Allows use of the Builder::XmlMarkup engine to be used with rendering.
      class Erubis < Mack::Rendering::Engine::Base
        
        def render(io, binding)
          src = Mack::Rendering::Engine::Erubis::TemplateCache.instance.cache[io]
          if src.nil?
            src = ::Erubis::Eruby.new(io).src
            Mack::Rendering::Engine::Erubis::TemplateCache.instance.cache[io] = src
          end
          eval(src, binding)
        end
        
        def extension
          :erb
        end
        
        def concat(txt, b)
          eval( "_buf", b) << txt
        end
        
        private
        class TemplateCache
          include Singleton
          
          attr_reader :cache
          
          def initialize
            @cache = {}
          end
          
        end
        
      end # Erubis
    end # Engines
  end # Rendering
end # Mack
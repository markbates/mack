require File.join(File.dirname(__FILE__), 'base')
module Mack
  module Rendering
    module Engine
      class Haml < Mack::Rendering::Engine::Base
        
        def render(io, binding)
          ::Haml::Engine.new(io).render(binding)
        end
        
        def extension
          :haml
        end
        
      end
    end
  end
end
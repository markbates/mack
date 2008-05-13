module Mack
  module Rendering
    module Engines
      class Text < Mack::Rendering::Engines::Base
        
        def render
          self.view_template.engine_type_value
        end
        
      end # Text
    end # Engines
  end # Rendering
end # Mack
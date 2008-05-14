module Mack
  module Rendering
    module Type
      class Text < Mack::Rendering::Type::Base
        
        def render
          self.view_template.engine_type_value
        end
        
      end
    end
  end
end
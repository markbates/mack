module Mack
  module Rendering
    module Type
      class Text < Mack::Rendering::Type::Base
        
        def render
          self.render_value
        end
        
      end
    end
  end
end
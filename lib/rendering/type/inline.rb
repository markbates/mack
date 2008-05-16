module Mack
  module Rendering
    module Type
      class Inline < Mack::Rendering::Type::Base
        
        def render
          @engine = engine((self.options[:engine] || :erubis)).new(self.view_template)
          return @engine.render(self.desired_render_value, self.binder)
        end
        
        def concat(txt, b)
          @engine.concat(txt, b)
        end
        
      end
    end
  end
end
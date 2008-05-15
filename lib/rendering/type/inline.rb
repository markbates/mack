module Mack
  module Rendering
    module Type
      class Inline < Mack::Rendering::Type::Base
        
        def render
          engine = engine((self.options[:engine] || :erubis)).new(self.view_template)
          return engine.render(self.view_template.engine_type_value, self.view_template.binder)
        end
        
      end
    end
  end
end
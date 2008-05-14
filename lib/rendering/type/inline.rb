module Mack
  module Rendering
    module Type
      class Inline < Mack::Rendering::Type::Base
        
        def render
          engine = engine((self.options[:engine] || :erubis)).new
          return engine.render(self.view_template.engine_type_value, self.view_template.binder)
          # Mack::Rendering::Type::Action.engines.each do |e|
          #   engine = engine(e).new
          #   
          #   find_file(self.view_template.controller_view_path, "#{self.view_template.engine_type_value}.#{self.options[:format]}.#{engine.extension}") do |f|
          #     return engine.render(File.open(f).read, self.view_template.binder)
          #   end
          #   
          # end
        end
        
      end
    end
  end
end
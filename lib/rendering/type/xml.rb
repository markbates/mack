module Mack
  module Rendering
    module Type
      class Xml < Base
        
        def render
          Mack::Rendering::Type::Xml.engines.each do |e|
            engine = engine(e).new(self.view_template)
            
            find_file(self.view_template.controller_view_path, "#{self.view_template.engine_type_value}.#{self.options[:format]}.#{engine.extension}") do |f|
              return engine.render(File.open(f).read, self.view_template.binder)
            end
            
          end
        end
        
        class << self
          
          def engines
            [:builder]
          end
          
        end
        
      end
    end
  end
end
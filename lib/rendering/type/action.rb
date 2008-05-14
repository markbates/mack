require File.join(File.dirname(__FILE__), 'base')
module Mack
  module Rendering
    module Type
      class Action < Mack::Rendering::Type::Base
        
        def render
          Mack::Rendering::Type::Action.engines.each do |e|
            engine = engine(e).new
            
            find_file(self.view_template.controller_view_path, "#{self.view_template.engine_type_value}.#{self.options[:format]}.#{engine.extension}") do |f|
              return engine.render(File.open(f).read, self.view_template.binder)
            end
            
          end
        end
        
        class << self
          
          def engines
            [:erubis, :haml, :markaby]
          end
          
        end
        
      end
    end
  end
end
module Mack
  module Rendering
    module Type
      class Layout < Mack::Rendering::Type::Base
        
        def render
          Mack::Rendering::Type::Layout.engines.each do |e|
            engine = engine(e).new
            
            find_file(Mack::Configuration.views_directory, 'layouts', "#{self.options[:layout]}.#{self.options[:format]}.#{engine.extension}") do |f|
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
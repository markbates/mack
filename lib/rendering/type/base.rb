module Mack
  module Rendering
    module Type
      class Base
        
        attr_reader :view_template
        
        def initialize(view_template)
          @view_template = view_template
        end
        
        needs_method :render
        
        def find_file(*path)
          f = File.join(path)
          puts f
          if File.exists?(f)
            yield f
          end
        end
        
        def allow_layout?
          true
        end
        
        def options
          self.view_template.options
        end
        
        def engine(e)
          eval("Mack::Rendering::Engine::#{e.to_s.camelcase}")
        end
        
      end
    end
  end
end
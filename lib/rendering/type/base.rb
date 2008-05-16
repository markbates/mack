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
          if File.exists?(f)
            yield f
          end
        end
        
        def allow_layout?
          true
        end
        
        def find_engine(e)
          eval("Mack::Rendering::Engine::#{e.to_s.camelcase}")
        end
        
        def method_missing(sym, *args)
          self.view_template.send(sym, *args)
        end
        
        def controller_view_path
          ivar_cache do
            File.join(Mack::Configuration.views_directory, self.controller.controller_name)
          end
        end
        
      end
    end
  end
end
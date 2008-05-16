module Mack
  module Rendering # :nodoc:
    module Type # :nodoc:
      # Mack::Rendering::Type objects need to extend this class.
      # 
      # The method 'render' needs to be implemented as in all subclasses.
      class Base
        
        # Returns the Mack::Rendering::ViewTemplate object associated with this render.
        attr_reader :view_template
        
        def initialize(view_template)
          @view_template = view_template
        end
        
        needs_method :render
        
        # If a file is found on disk it will be yielded up.
        # 
        # Example:
        #   find_file("path", "to", "my", "file") do |f|
        #     puts File.open(f).read
        #   end
        def find_file(*path)
          f = File.join(path)
          if File.exists?(f)
            yield f
          end
        end
        
        # Can be overridden by subclasses to prevent layouts being used with the render.
        def allow_layout?
          true
        end
        
        def find_engine(e)
          eval("Mack::Rendering::Engine::#{e.to_s.camelcase}")
        end
        
        def method_missing(sym, *args)
          self.view_template.send(sym, *args)
        end
        
        # Returns the directory path for the current controller.
        def controller_view_path
          ivar_cache do
            File.join(Mack::Configuration.views_directory, self.controller.controller_name)
          end
        end
        
      end
    end
  end
end
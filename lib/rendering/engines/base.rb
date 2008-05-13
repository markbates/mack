module Mack
  module Rendering
    module Engines
      class Base
        
        attr_reader :view_template
        attr_reader :engine_settings
        
        def initialize(view_template, engine_settings)
          @view_template = view_template
          @engine_settings = engine_settings
          self.view_template.options[:layout] = false unless self.use_layout?
        end
        
        needs_method :render
        
        def find_file(*path)
          f = File.join(path)
          if File.exists?(f)
            yield f
          end
        end
        
        def use_layout?
          true
        end
        
      end # Erb
    end # Engines
  end # Rendering
end # Mack
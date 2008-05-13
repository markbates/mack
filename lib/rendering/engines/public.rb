module Mack
  module Rendering
    module Engines
      class Public < Mack::Rendering::Engines::Base
        
        def render
          p_file = "#{self.view_template.engine_type_value}.#{self.view_template.options[:format]}"
          find_file(Mack::Configuration.public_directory, p_file) do |f|
            return File.open(f).read
          end
          raise Mack::Errors::ResourceNotFound.new(p_file)
        end
        
        def use_layout?
          false
        end
        
      end # Public
    end # Engines
  end # Rendering
end # Mack
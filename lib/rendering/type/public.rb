module Mack
  module Rendering
    module Type
      class Public < Mack::Rendering::Type::Base
        
        def render
          p_file = "#{self.view_template.engine_type_value}.#{self.options[:format]}"
          find_file(Mack::Configuration.public_directory, p_file) do |f|
            return File.open(f).read
          end
          raise Mack::Errors::ResourceNotFound.new(p_file)
        end
        
        def allow_layout?
          false
        end
        
      end
    end
  end
end
module Mack
  module Rendering
    module Type
      class Partial < Mack::Rendering::Type::Base
        
        def render
          partial = self.render_value.to_s
          parts = partial.split("/")
          if parts.size == 1
            # it's local to this controller
            partial = "_" << partial
            partial = File.join(self.controller_view_path, partial)
          else
            # it's elsewhere
            parts[parts.size - 1] = "_" << parts.last
            partial = File.join(Mack::Configuration.views_directory, parts)
          end
          Mack::Rendering::Engine::Registry.engines[:partial].each do |e|
            engine = engine(e).new(self.view_template)
            find_file("#{partial}.#{self.options[:format]}.#{engine.extension}") do |f|
              return engine.render(File.open(f).read, self.binder)
            end
          end
          raise Mack::Errors::ResourceNotFound.new("#{partial}.#{self.options[:format]}")
        end
        
        def allow_layout?
          false
        end
        
      end
    end
  end
end
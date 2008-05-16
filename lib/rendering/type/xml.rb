module Mack
  module Rendering
    module Type
      class Xml < Mack::Rendering::Type::Base
        
        def render
          x_file = File.join(self.controller_view_path, "#{self.render_value}.#{self.options[:format]}")
          Mack::Rendering::Engine::Registry.engines[:xml].each do |e|
            engine = engine(e).new(self.view_template)
            find_file(x_file + ".#{engine.extension}") do |f|

              return engine.render(File.open(f).read, self.binder)
            end
          end
          raise Mack::Errors::ResourceNotFound.new(x_file)
        end
        
      end
    end
  end
end
module Mack
  module Rendering
    module Type
      class Layout < Mack::Rendering::Type::Base
        
        def render
          l_file = File.join(Mack::Configuration.views_directory, 'layouts', "#{self.options[:layout]}.#{self.options[:format]}")
          Mack::Rendering::Engine::Registry.engines[:layout].each do |e|
            engine = engine(e).new(self.view_template)
            find_file(l_file + ".#{engine.extension}") do |f|
              return engine.render(File.open(f).read, self.binder)
            end
          end
          raise Mack::Errors::ResourceNotFound.new(l_file)
        end
        
      end
    end
  end
end
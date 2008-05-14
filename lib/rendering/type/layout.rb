module Mack
  module Rendering
    module Type
      class Layout < Mack::Rendering::Type::Base
        
        def render
          Mack::Rendering::Engine::Registry.engines[:layout].each do |e|
            engine = engine(e).new
            
            find_file(Mack::Configuration.views_directory, 'layouts', "#{self.options[:layout]}.#{self.options[:format]}.#{engine.extension}") do |f|
              return engine.render(File.open(f).read, self.view_template.binder)
            end
            
          end
        end
        
      end
    end
  end
end
require File.join(File.dirname(__FILE__), 'base')
module Mack
  module Rendering
    module Type
      class FileBase < Mack::Rendering::Type::Base
        
        # Returns a string representing the file stored on disk, once it's be run through
        # the first found Mack::Rendering::Engine object associated with this Mack::Rendering::Type.
        # 
        # Since engines are stored in an array, the are looped through until a template is found on disk.
        # If no template is found then a Mack::Errors::ResourceNotFound exception is thrown.
        def render_file(file, type = :action)
          Mack::Rendering::Engine::Registry.engines[type].each do |e|
            @engine = find_engine(e).new(self.view_template)
            find_file(file + ".#{@engine.extension}") do |f|
              return @engine.render(File.new(f), self.binder)
            end
          end
          raise Mack::Errors::ResourceNotFound.new(file + ".*")
        end
        
        # Passes concatenation messages through to the Mack::Rendering::Engine object.
        # This should append the text, using the passed in binding, to the final output
        # of the render.
        def concat(txt, b)
          @engine.concat(txt, b)
        end
        
      end # FileBase
    end # Type
  end # Rendering
end # Mack
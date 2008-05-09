module Mack
  module Rendering
    module Engines
      module Erb
        
        def self.render(io, binding)
          Erubis::Eruby.new(io).result(binding)
        end
        
      end # Erb
    end # Engines
  end # Rendering
end # Mack
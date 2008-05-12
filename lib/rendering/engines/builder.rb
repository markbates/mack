module Mack
  module Rendering
    module Engines
      class Builder
        
        def initialize()
          @xml_output = ""
          @xml = ::Builder::XmlMarkup.new(:target => @xml_output, :indent => 1)
          self
        end
        
        def xml
          @xml
        end
        
        def render(io, binding)
          eval(io, binding)
        end
        
      end # Erb
    end # Engines
  end # Rendering
end # Mack
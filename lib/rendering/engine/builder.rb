module Mack
  module Rendering
    module Engine
      class Builder < Base
        
        def initialize(view_template)
          @xml = ::Builder::XmlMarkup.new(:target => @xml_output, :indent => 1)
          view_template.instance_variable_set("@xml", @xml)
        end
        
        def render(io, binding)
          return eval(io, binding)
        end
        
        def extension
          :builder
        end
        
      end # Builder
    end # Engine
  end # Rendering
end # Mack
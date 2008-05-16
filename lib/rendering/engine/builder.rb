module Mack
  module Rendering
    module Engine
      class Builder < Mack::Rendering::Engine::Base
        
        def initialize(view_template)
          super
          @_xml = ::Builder::XmlMarkup.new(:target => @_xml_output, :indent => 1)
          view_template.instance_variable_set("@_xml", @_xml)
        end
        
        def render(io, binding)
          eval(io, binding)
        end
        
        def extension
          :builder
        end
        
      end # Builder
    end # Engine
  end # Rendering
end # Mack
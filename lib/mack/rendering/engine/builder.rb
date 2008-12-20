require File.join(File.dirname(__FILE__), '..', "view_template")
require File.join(File.dirname(__FILE__), 'base')
module Mack
  module Rendering # :nodoc:
    module Engine # :nodoc:
      # Allows use of the Builder::XmlMarkup engine to be used with rendering.
      class Builder < Mack::Rendering::Engine::Base
        
        def render(io, binding)
          if io.is_a?(File)
            io = io.read
          end
          @_xml = ::Builder::XmlMarkup.new(:target => @_xml_output, :indent => 1)
          view_template.instance_variable_set("@_xml", @_xml)
          eval(io, binding)
        end
        
        def extension
          :builder
        end
        
        # Used to give XmlBuilder templates access to a 'root' xml object.
        module ViewTemplateHelpers
          def xml
            @_xml
          end
        end # ViewTemplateHelpers
        
      end # Builder
    end # Engine
  end # Rendering
end # Mack

Mack::Rendering::ViewTemplate.send(:include, Mack::Rendering::Engine::Builder::ViewTemplateHelpers)
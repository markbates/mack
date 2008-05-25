require File.join(File.dirname(__FILE__), "..", "view_template")
require File.join(File.dirname(__FILE__), "base")
module Mack
  module Rendering
    module Engine
      class Markaby < Mack::Rendering::Engine::Base
        
        def render(io, binding)
          @_markaby = ::Markaby::Builder.new({}, self.view_template)
          self.view_template.instance_variable_set("@_markaby", @_markaby)
          eval(io, binding)
        end
        
        def extension
          :mab
        end
        
        module ViewHelpers
          def mab
            @_markaby
          end
        end
        
      end
    end
  end
end
Mack::Rendering::ViewTemplate.send(:include, Mack::Rendering::Engine::Markaby::ViewHelpers)
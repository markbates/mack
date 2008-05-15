module Mack
  module Rendering
    module Engine
      class Base

        attr_reader :view_template

        def initialize(view_template)
          @view_template = view_template
        end

      end # Base
    end # Engines
  end # Rendering
end # Mack
module Mack
  module Rendering # :nodoc:
    module Engine # :nodoc:
      # Engines are used to transform a IO, using a supplied binding to a String.
      # 
      # The method 'render' needs to be implemented as render(io, binding) in all subclasses.
      class Base

        # The Mack::Rendering::ViewTemplate object to be used with this engine.
        attr_reader :view_template

        def initialize(view_template)
          @view_template = view_template
        end

        needs_method :render

      end # Base
    end # Engines
  end # Rendering
end # Mack
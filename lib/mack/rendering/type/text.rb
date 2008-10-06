require File.join(File.dirname(__FILE__), 'base')
module Mack
  module Rendering # :nodoc:
    module Type # :nodoc:
      # This is pretty damn brain dead, it just returns the text you supplied to it.
      # 
      # Example:
      #   <%= render(:text, "Hello World") %> # => "Hello World"
      class Text < Mack::Rendering::Type::Base
        
        def render
          self._render_value
        end
        
      end # Text
    end # Type
  end # Rendering
end # Mack
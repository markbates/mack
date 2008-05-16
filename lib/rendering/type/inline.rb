module Mack
  module Rendering # :nodoc:
    module Type # :nodoc:
      # This class allows for a template to be rendered inline in a controller, and not served from disk.
      # 
      # Examples:
      #   <%= render(:inline, "<%= 2 + 2 %> should equal 4") %> # => "4 should equal 4"
      #   <%= render(:inline, "xml.hello("Mark")", :engine => :builder) %> # => "<hello>Mark</hello>"
      class Inline < Mack::Rendering::Type::Base
        
        def render
          @engine = find_engine((self.options[:engine] || :erubis)).new(self.view_template)
          return @engine.render(self.render_value, self.binder)
        end
        
        # Passes concatenation messages through to the Mack::Rendering::Engine object.
        # This should append the text, using the passed in binding, to the final output
        # of the render.
        def concat(txt, b)
          @engine.concat(txt, b)
        end
        
      end # Inline
    end # Type
  end # Rendering
end # Mack
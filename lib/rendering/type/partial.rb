require File.join(File.dirname(__FILE__), 'file_base')
module Mack
  module Rendering # :nodoc:
    module Type # :nodoc:
      # Used to render partials. Partials are small reusable templates. They have to start with an _.
      # 
      # Example:
      #   <%= render(:partial, "users/form") %> # => /users/_form.html.erb
      class Partial < Mack::Rendering::Type::FileBase
        
        # See Mack::Rendering::Type::FileBase render_file for more information.
        # 
        # The path to the file is built like such:
        #   app/views/#{controller name}/#{partial name with prefixed _}.#{format (html, xml, js, etc...)}.#{extension defined in the engine}
        # Example:
        #   app/views/users/_form.html.erb 
        def render
          partial = self.render_value.to_s
          parts = partial.split("/")
          if parts.size == 1
            # it's local to this controller
            partial = "_" << partial
            partial = File.join(self.controller_view_path, partial)
          else
            # it's elsewhere
            parts[parts.size - 1] = "_" << parts.last
            partial = File.join(Mack::Configuration.views_directory, parts)
          end
          partial = "#{partial}.#{self.options[:format]}"
          render_file(partial, :partial)
        end
        
        # No layouts should be used with this Mack::Rendering::Type
        def allow_layout?
          false
        end
        
      end # Partial
    end # Type
  end # Rendering
end # Mack
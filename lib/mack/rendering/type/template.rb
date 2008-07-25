require File.join(File.dirname(__FILE__), 'file_base')
module Mack
  module Rendering # :nodoc:
    module Type # :nodoc:
      # Pretty much the same thing as Mack::Rendering::Type::Action, except the template is relative to the app/views directory,
      # and not the app/views/#{controller name} directory like action.
      class Template < Mack::Rendering::Type::FileBase
        
        # See Mack::Rendering::Type::FileBase render_file for more information.
        # 
        # The path to the file is built like such:
        #   app/views/#{template (show, index, etc...)}.#{format (html, xml, js, etc...)}.#{extension defined in the engine}
        # Example:
        #   <%= render(:template, "users/show") %> # => app/views/users/show.html.erb
        def render
          t_file = File.join(Mack.root, "app", "views", "#{self.render_value}.#{self.options[:format]}")
          render_file(t_file, :template)
        end
        
      end # Template
    end # Type
  end # Rendering
end # Mack
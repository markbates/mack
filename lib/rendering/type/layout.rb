module Mack
  module Rendering # :nodoc:
    module Type # :nodoc:
      # Used to render layouts around views.
      class Layout < Mack::Rendering::Type::FileBase
        
        # See Mack::Rendering::Type::FileBase render_file for more information.
        # 
        # The path to the file is built like such:
        #   app/views/layouts/#{options[:layout] || "application"}.#{format (html, xml, js, etc...)}.#{extension defined in the engine}
        # Example:
        #   app/views/layouts/application.html.erb 
        def render
          l_file = File.join(Mack::Configuration.views_directory, 'layouts', "#{self.options[:layout]}.#{self.options[:format]}")
          render_file(l_file, :layout)
        end
        
      end # Layout
    end # Type
  end # Rendering
end # Mack
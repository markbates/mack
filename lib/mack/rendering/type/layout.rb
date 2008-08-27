require File.join(File.dirname(__FILE__), 'file_base')
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
          l_file = Mack::Paths.layouts("#{self.options[:layout]}.#{self.options[:format]}")
          begin
            render_file(l_file, :layout)
          rescue Mack::Errors::ResourceNotFound => e
            Mack.logger.warn(e)
            self.view_template.yield_to :view
          end
        end
        
      end # Layout
    end # Type
  end # Rendering
end # Mack
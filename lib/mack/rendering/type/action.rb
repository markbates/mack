require File.join(File.dirname(__FILE__), 'file_base')
module Mack
  module Rendering # :nodoc:
    module Type # :nodoc:
      # Used to render a template that's relative to a controller.
      # 
      # Example:
      #   class UsersController
      #     include Mack::Controller
      #     # /users/:id
      #     def show
      #       @user = User.first(params[:id])
      #     end
      #     # /users
      #     def index
      #       @users = User.all
      #       render(:action, :list)
      #     end
      #   end
      # When some calls /users/1 the file: app/views/users/show.html.erb will be rendered.
      # When some calls /users the file: app/views/users/list.html.erb will be rendered.
      class Action < Mack::Rendering::Type::FileBase
        
        # See Mack::Rendering::Type::FileBase render_file for more information.
        # 
        # The path to the file is built like such:
        #   app/views/#{controller name}/#{render_value || action name (show, index, etc...)}.#{format (html, xml, js, etc...)}.#{extension defined in the engine}
        # Example:
        #   app/views/users/show.html.erb 
        def render
          a_file = File.join(self.controller_view_path, "#{self.render_value}.#{self.options[:format]}")
          render_file(a_file)
        end
        
      end # Action
    end # Type
  end # Rendering
end # Mack
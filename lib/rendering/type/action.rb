require File.join(File.dirname(__FILE__), 'base')
module Mack
  module Rendering # :nodoc:
    module Type # :nodoc:
      # Used to render a template that's relative to a controller.
      # 
      # Example:
      #   class UsersController < Mack::Controller::Base
      #     # /users/:id
      #     def show
      #       @user = User.first(params(:id))
      #     end
      #     # /users
      #     def index
      #       @users = User.all
      #       render(:action, :list)
      #     end
      #   end
      # When some calls /users/1 the file: app/views/users/show.html.erb will be rendered.
      # When some calls /users the file: app/views/users/list.html.erb will be rendered.
      class Action < Mack::Rendering::Type::Base
        
        # Returns a string representing the action stored on disk, once it's be run through
        # the first found Mack::Rendering::Engine object associated with this Mack::Rendering::Type.
        # 
        # The path to the file is built like such:
        #   app/views/#{controller name}/#{render_value || action name (show, index, etc...)}.#{format (html, xml, js, etc...)}.#{extension defined in the engine}
        # Example:
        #   app/views/users/show.html.erb 
        # 
        # Since engines are stored in an array, the are looped through until a template is found on disk.
        # If no template is found then a Mack::Errors::ResourceNotFound exception is thrown.
        def render
          a_file = File.join(self.controller_view_path, "#{self.render_value}.#{self.options[:format]}")
          Mack::Rendering::Engine::Registry.engines[:action].each do |e|
            @engine = find_engine(e).new(self.view_template)
            find_file(a_file + ".#{@engine.extension}") do |f|
              return @engine.render(File.open(f).read, self.binder)
            end
          end
          raise Mack::Errors::ResourceNotFound.new(a_file + ".*")
        end
        
        # Passes concatenation messages through to the Mack::Rendering::Engine object.
        # This should append the text, using the passed in binding, to the final output
        # of the render.
        def concat(txt, b)
          @engine.concat(txt, b)
        end
        
      end
    end
  end
end
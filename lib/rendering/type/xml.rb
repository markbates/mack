require File.join(File.dirname(__FILE__), "..", "view_template")
module Mack
  module Rendering # :nodoc:
    module Type # :nodoc:
      # Used to render an XML template that's relative to a controller.
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
      # When some calls /users/1.xml the file: app/views/users/show.xml.builder will be rendered.
      # When some calls /users.xml the file: app/views/users/list.xml.builder will be rendered.
      class Xml < Mack::Rendering::Type::FileBase
        
        # See Mack::Rendering::Type::FileBase render_file for more information.
        def render
          x_file = File.join(self.controller_view_path, "#{self.render_value}.#{self.options[:format]}")
          render_file(x_file, :xml)
        end
        
        # Used to give XmlBuilder templates access to a 'root' xml object.
        module ViewTemplateHelpers
          def xml
            @_xml
          end
        end # ViewTemplateHelpers
        
      end # Xml
    end # Type
  end # Rendering
end # Mack

Mack::Rendering::ViewTemplate.send(:include, Mack::Rendering::Type::Xml::ViewTemplateHelpers)
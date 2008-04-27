module Mack
  module ViewHelpers
    module OrmHelpers
      DEFAULT_PARTIAL = %{
        <div>
          <div class="errorExplanation" id="errorExplanation">
            <h2>Oi, there were errors! Fix `em!</h2>
            <ul>
              <% for error in errors %>
                <li><%= error %></li>
              <% end %>  
            </ul>
          </div>
        </div>
      }
  
      def error_messages_for(object_names = [], view_partial = nil)
        object_names = [object_names].flatten
        app_errors = []
        object_names.each do |name|
          object = instance_variable_get("@#{name}")
          if object
            if object.is_a?(ActiveRecord::Base)
              object.errors.each do |key, value|
                if value.match(/^\^/)
                  app_errors << value[1..value.length]
                else
                  if key.class == String and key == "base"
                    app_errors << "#{value}"
                  else
                    app_errors << "#{object.business_name} #{key.underscore.split('_').join(' ').humanize} #{value}"
                  end
                end
              end
            elsif object.is_a?(DataMapper::Persistence)
              app_errors << object.errors.full_messages
            end
          end
        end
        app_errors.flatten!
        File.join(MACK_VIEWS, "application", "_error_messages.html.erb")
        unless app_errors.empty?
          if view_partial.nil?
            if File.exist?(File.join(MACK_VIEWS, "application", "_error_messages.html.erb"))
              render :partial => "application/error_messages", :locals => {:errors => app_errors}
            else
              render :text => DEFAULT_PARTIAL, :locals => {:errors => app_errors}
            end
          else        
            render :partial => view_partial, :locals => {:errors => app_errors}
          end
        else
          ""
        end
      end
      # self.include_safely_into(Mack::ViewBinder)
    end # OrmHelpers
  end # ViewHelpers
end # Mack
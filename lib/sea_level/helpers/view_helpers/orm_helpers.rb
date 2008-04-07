if using_active_record?
  class ActiveRecord::Base # :nodoc:
    def business_display_name
      self.class.name#.titlecase
    end
  end
end

if using_data_mapper?
  class DataMapper::Base # :nodoc:
    def business_display_name
      self.class.name#.titlecase
    end
  end
end

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
        object_names = [object_names]
        object_names.flatten!
        app_errors = []
        object_names.each do |name| 
          object = instance_variable_get("@#{name}")
          if object
            object.errors.each do |key, value|
              key = key.to_s
              if value.is_a?(Array)
                value.each do |v|
                  if v.match(/^\^/)
                    app_errors << v[1..v.length]
                  else
                    if key.class == String and key == "base"
                      app_errors << "#{v}"
                    else
                      app_errors << "#{object.business_display_name} #{key.underscore.split('_').join(' ')} #{v}"
                    end
                  end
                end
              else
                if value.match(/^\^/)
                  app_errors << value[1..value.length]
                else
                  if key.class == String and key == "base"
                    app_errors << "#{value}"
                  else
                    app_errors << "#{object.business_display_name} #{key.underscore.split('_').join(' ')} #{value}"
                  end
                end
              end
            end
          end
        end
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
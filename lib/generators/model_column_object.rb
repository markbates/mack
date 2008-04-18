module Mack
  module Generator
    
    # Used to represent a 'column' from the param cols or columns for generators.
    class ModelColumnObject
      
      # The name of the column.
      attr_accessor :column_name
      # The type of the column. Ie. string, integer, datetime, etc...
      attr_accessor :column_type
      # The name of the model associated with the column. Ie. user, post, etc...
      attr_accessor :model_name
      
      # Takes in the model_name (user, post, etc...) and the column (username:string, body:text, etc...)
      def initialize(model_name, column_unsplit)
        self.model_name = model_name.singular.underscore
        cols = column_unsplit.split(":")
        self.column_name = cols.first.singular.underscore
        self.column_type = cols.last.singular.underscore
      end
      
      # Examples:
      #   Mack::Generator::ColumnObject.new("user", "username:string").form_element_name # => "user[username]"
      #   Mack::Generator::ColumnObject.new("Post", "body:text").form_element_name # => "post[body]"
      def form_element_name
        "#{self.model_name}[#{self.column_name}]"
      end

      # Examples:
      #   Mack::Generator::ColumnObject.new("user", "username:string").form_element_id # => "user_username"
      #   Mack::Generator::ColumnObject.new("Post", "body:text").form_element_id # => "post_body"
      def form_element_id
        "#{self.model_name}_#{self.column_name}"
      end

      # Generates the appropriate HTML form field for the type of column represented.
      # 
      # Examples:
      #   Mack::Generator::ColumnObject.new("user", "username:string").form_field 
      #     => "<input type="text" name="user[username]" id="user_username" size="30" value="<%= user.username %>" />"
      #   Mack::Generator::ColumnObject.new("Post", "body:text").form_field
      #     => "<textarea name="post[body]" id="post_id"><%= post.body %></textarea>"
      def form_field
        case self.column_type
        when "text"
          %{<textarea name="#{self.form_element_name}" id="#{self.form_element_id}"><%= @#{self.model_name}.#{self.column_name} %></textarea>}
        else
          %{<input type="text" name="#{self.form_element_name}" id="#{self.form_element_id}" size="30" value="<%= @#{self.model_name}.#{self.column_name} %>" />}
        end
      end
      
    end # ModelColumnObject
    
  end # Generator
end # Mack
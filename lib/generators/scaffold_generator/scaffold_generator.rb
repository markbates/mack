# Generates scaffold for Mack applications.
# 
# Example:
#   rake generate:scaffold name=post
class ScaffoldGenerator < Mack::Generator::Base
  
  require_param :name
  
  def generate # :nodoc:
    @name_singular = param(:name).singular.underscore
    @name_plural = param(:name).plural.underscore
    @name_singular_camel = @name_singular.camelcase
    @name_plural_camel = @name_plural.camelcase
    
    # update routes.rb
    routes = File.join(MACK_CONFIG, "routes.rb")
    rf = File.open(routes).read
    unless rf.match(".resource :#{@name_plural}")
      puts "Updating routes.rb"
      nrf = ""
      rf.each do |line|
        if line.match("Mack::Routes.build")
          x = line.match(/\|(.+)\|/).captures
          line << "\n  #{x}.resource :#{@name_plural} # Added by rake generate:scaffold name=#{param(:name)}\n"
        end
        nrf << line
      end
      File.open(routes, "w") do |f|
        f.puts nrf
      end
    end 
    
    app_cont_dir = File.join(MACK_APP, "controllers")
    directory(app_cont_dir)
    
    temp_dir = File.join(File.dirname(__FILE__), "templates")

    if app_config.orm
      app_model_dir = File.join(MACK_APP, "models")
      directory(app_model_dir)

      app_views_dir = File.join(MACK_APP, "views", @name_plural)
      directory(app_views_dir)
      
      template(File.join(temp_dir, "generic", "app", "controllers", "controller.rb.template"), File.join(app_cont_dir, "#{@name_plural}_controller.rb"), :force => param(:force))
      template(File.join(temp_dir, "generic", "app", "views", "index.html.erb.template"), File.join(app_views_dir, "index.html.erb"), :force => param(:force))
      template(File.join(temp_dir, "generic", "app", "views", "edit.html.erb.template"), File.join(app_views_dir, "edit.html.erb"), :force => param(:force))
      template(File.join(temp_dir, "generic", "app", "views", "new.html.erb.template"), File.join(app_views_dir, "new.html.erb"), :force => param(:force))
      template(File.join(temp_dir, "generic", "app", "views", "show.html.erb.template"), File.join(app_views_dir, "show.html.erb"), :force => param(:force))
      ModelGenerator.new("NAME" => param(:name)).run
    else
      template(File.join(temp_dir, "no_orm", "app", "controllers", "controller.rb.template"), File.join(app_cont_dir, "#{@name_plural}_controller.rb"), :force => param(:force))
    end

  end
  
  def form_from_cols
    form = ""
    cols = (param(:cols) || param(:columns))
    if cols
      cols = cols.split("|")
      cols.each_with_index do |v, i|
        x = v.split(":")
        col = x.first
        type = x.last
        # <p>
        #   <b>Email</b><br />
        #   <input id="post_email" name="post[email]" size="30" type="text" value="<%= @post.email %>" />
        # </p>
        form_element_name = "#{@name_singular}[#{col}]"
        form_element_id = "#{@name_singular}_#{col}"
        form << "<p>\n"
        form << "  <b>#{col.singular.camelcase}</b><br />\n"
        case type
        when "text"
          # <textarea name="zoo[description]" id="zoo_description"><%= @zoo.description %></textarea>
          form << %{  <textarea name="#{form_element_name}" id="#{form_element_id}"><%= @#{@name_singular}.#{col} %></textarea>\n}
        else
          # <input id="post_email" name="post[email]" size="30" type="text" value="<%= @post.email %>" />
          form << %{  <input type="text" name="#{form_element_name}" id="#{form_element_id}" size="30" value="<%= @#{@name_singular}.#{col} %>">\n}
        end
        form << "</p>\n"
      end
    end
    form
  end
  
  def columns
    ivar_cache("form_columns") do
      cs = []
      cols = (param(:cols) || param(:columns))
      if cols
        cols.split("|").each do |x|
          cs << ColumnObject.new(@name_singular, x)
        end
      end
      cs
    end
  end
  
  class ColumnObject
    attr_accessor :column_name
    attr_accessor :column_type
    attr_accessor :model_name
    def initialize(model_name, column_unsplit)
      self.model_name = model_name
      cols = column_unsplit.split(":")
      self.column_name = cols.first
      self.column_type = cols.last
    end
    
    def form_element_name
      "#{self.model_name}[#{self.column_name}]"
    end
    
    def form_element_id
      "#{self.model_name}_#{self.column_name}"
    end
    
    def form_field
      case self.column_type
      when "text"
        %{<textarea name="#{self.form_element_name}" id="#{self.form_element_id}"><%= @#{self.model_name}.#{self.column_name} %></textarea>}
      else
        %{<input type="text" name="#{self.form_element_name}" id="#{self.form_element_id}" size="30" value="<%= @#{self.model_name}.#{self.column_name} %>" />}
      end
    end
    
  end
  
end
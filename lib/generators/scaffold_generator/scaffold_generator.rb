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
      ModelGenerator.run(@env)
    else
      template(File.join(temp_dir, "no_orm", "app", "controllers", "controller.rb.template"), File.join(app_cont_dir, "#{@name_plural}_controller.rb"), :force => param(:force))
    end

  end
  
end
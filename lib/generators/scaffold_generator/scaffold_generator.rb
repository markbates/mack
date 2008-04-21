# Generates scaffold for Mack applications.
# 
# Example:
#   rake generate:scaffold name=post
class ScaffoldGenerator < Genosaurus
  
  require_param :name
  
  def setup
    @name_singular = param(:name).singular.underscore
    @name_plural = param(:name).plural.underscore
    @name_singular_camel = @name_singular.camelcase
    @name_plural_camel = @name_plural.camelcase    
  end
  
  def after_generate
    if app_config.orm
      ModelGenerator.run(@options)
    end
    update_routes_file
  end
  
  def update_routes_file
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
  end
  
end
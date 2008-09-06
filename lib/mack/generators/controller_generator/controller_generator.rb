# Generates a controller for Mack applications.
# 
# Example:
#   rake generate:controller name=post # => Generates a PostsController that includes Mack::Controller.
# 
# Or you can get the generator to create some actions for you this way:
#   rake generator:controller name=post actions=index,show # => Generates a PostController with a placeholder for the index and show actions.
#   
# Finally, the controller generator includes a magic word for the actions parameter:
#   rake generator:controller name=post actions=restful # => Generates a PostsController with the 7 rest actions.
class ControllerGenerator < Genosaurus
  
  require_param :name
  
  def setup # :nodoc:
    @name_singular = param(:name).singular.underscore
    @name_plural = param(:name).plural.underscore
    @name_singular_camel = @name_singular.camelcase
    @name_plural_camel = @name_plural.camelcase
    @actions = []
    if param(:actions).to_s == "restful"
      @actions = "index,show,new,edit,create,update,destroy".split(",")
    else      
      @actions = param(:actions).split(",") unless param(:actions).blank?
    end
  end
  
  def after_generate # :nodoc:
    add_actions
    update_routes_file
    ControllerHelperGenerator.run(@options)
  end
  
  private
  def update_routes_file # :nodoc:
    unless @actions.empty?
      routes = Mack::Paths.config("routes.rb")
      rf = File.open(routes).read
      unless rf.match(".resource :#{@name_plural}")
        puts "Updating routes.rb"
        nrf = ""
        rf.each do |line|
          if line.match("Mack::Routes.build")
            x = line.match(/\|(.+)\|/).captures
            line << "\n  # Added by rake generate:controller name=#{param(:name)} actions=#{param(:actions)}"
            line << "\n  r.with_options(:controller => :#{@name_plural}) do |map|"
            @actions.each do |action|
              line << "\n    map.#{@name_plural}_#{action} \"/#{@name_plural}#{action == "index" ? "" : "/#{action}"}\", :action => :#{action}"
            end
            line << "\n  end # #{@name_plural}\n"
          end
          nrf << line
        end
        File.open(routes, "w") do |f|
          f.puts nrf
        end
      end
    end
  end
  
  def add_actions
    @actions.each do |action|
      template(action_template(action), File.join("app", "views", @name_plural, "#{action}.html.erb"))
    end    
  end
  
  def action_template(action) # :nodoc:
    %{
<h1>#{@name_plural_camel}Controller##{action}</h1>
<p>You can find me in app/views/#{@name_plural}/#{action}.html.erb</p>
    }.strip
  end
  
end
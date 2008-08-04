# Generates a controller for Mack applications.
# 
# Example:
#   rake generate:controller name=post
class ControllerGenerator < Genosaurus
  
  require_param :name
  
  def setup # :nodoc:
    @name_singular = param(:name).singular.underscore
    @name_plural = param(:name).plural.underscore
    @name_singular_camel = @name_singular.camelcase
    @name_plural_camel = @name_plural.camelcase
    @actions = []
    @actions = param(:actions).split(",") unless param(:actions).blank?
  end
  
  def after_generate # :nodoc:
    @actions.each do |action|
      template(action_template(action), File.join("app", "views", @name_plural, "#{action}.html.erb"))
    end
    ControllerHelperGenerator.run(@options)
  end
  
  def action_template(action) # :nodoc:
    %{
<h1>#{@name_plural_camel}Controller##{action}</h1>
<p>You can find me in app/views/#{@name_plural}/#{action}.html.erb</p>
    }.strip
  end
  
end
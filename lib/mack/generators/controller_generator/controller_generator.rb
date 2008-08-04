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
  end
  
  def after_generate
    ControllerHelperGenerator.run(@options)
  end
  
end
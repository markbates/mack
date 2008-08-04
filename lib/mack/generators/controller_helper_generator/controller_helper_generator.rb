# Generates controller helpers for Mack applications.
# 
# Example:
#   rake generate:controller_helper name=post
class ControllerHelperGenerator < Genosaurus
  
  require_param :name
  
  def setup # :nodoc:
    @name_singular = param(:name).singular.underscore
    @name_plural = param(:name).plural.underscore
    @name_singular_camel = @name_singular.camelcase
    @name_plural_camel = @name_plural.camelcase
  end
  
end
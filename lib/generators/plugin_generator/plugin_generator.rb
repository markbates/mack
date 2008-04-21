# Generates plugins for Mack applications.
# 
# Example:
#   rake generate:plugin name=my_cool_plugin
# This will generate the following in your mack application:
#   vendor/plugins/my_cool_plugin
#   vendor/plugins/my_cool_plugin/init.rb
#   vendor/plugins/my_cool_plugin/lib
#   vendor/plugins/my_cool_plugin/lib/my_cool_plugin.rb
class PluginGenerator < Genosaurus::Base
  
  require_param :name
  
  def setup
    @plugin_name = param(:name).underscore.downcase
  end
  
end
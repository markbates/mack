# Generates plugins for Mack applications.
# 
# Example:
#   rake generate:plugin name=my_cool_plugin
# This will generate the following in your mack application:
#   vendor/plugins/my_cool_plugin
#   vendor/plugins/my_cool_plugin/init.rb
#   vendor/plugins/my_cool_plugin/lib
#   vendor/plugins/my_cool_plugin/lib/my_cool_plugin.rb
class PluginGenerator < Mack::Generator::Base
  
  require_param :name
  
  def generate # :nodoc:
    plugin_dir = File.join(MACK_ROOT, "vendor", "plugins", param(:name).downcase)
    template_dir = File.join(File.dirname(__FILE__), "templates")
    
    # create vendor/plugins/<name>
    directory(plugin_dir)
    # create vendor/plugins/<name>/lib
    directory(File.join(plugin_dir, "lib"))
    # create vendor/plugins/<name>/lib/tasks
    directory(File.join(plugin_dir, "lib", "tasks"))
    
    # create vendor/plugins/<name>/init.rb
    template(File.join(template_dir, "init.rb.template"), File.join(plugin_dir, "init.rb"), :force => param(:force))
    # create vendor/plugins/<name>/lib/<name>.rb
    template(File.join(template_dir, "lib", "plugin.rb.template"), File.join(plugin_dir, "lib", "#{param(:name).downcase}.rb"), :force => param(:force))
    
  end
  
end
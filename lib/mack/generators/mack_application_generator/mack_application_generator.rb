require File.join(File.dirname(__FILE__), '..', '..', "version")
class MackApplicationGenerator < Genosaurus
  
  def app_name
    @options['app'].underscore.downcase
  end
  
  def testing_framework
    @options["testing_framework"]
  end
  
end
class MackApplicationGenerator < Genosaurus
  
  def app_name
    @options["app"].underscore.downcase
  end
  
  def testing_framework
    puts @options["testing_framework"]
    @options["testing_framework"]
  end
  
end
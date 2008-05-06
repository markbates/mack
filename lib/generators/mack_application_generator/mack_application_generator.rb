class MackApplicationGenerator < Genosaurus
  
  def app_name
    @options["app"].underscore.downcase
  end
  
end
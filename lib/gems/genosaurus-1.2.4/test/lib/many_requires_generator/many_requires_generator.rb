class ManyRequiresGenerator < Genosaurus
  require_param :first_name
  require_param :last_name
  
  def self.description_detail
    %{
This generator requires many things.
These things can be used like such:

  first_name=Mark
  last_name=Bates
    }.strip
  end
  
end
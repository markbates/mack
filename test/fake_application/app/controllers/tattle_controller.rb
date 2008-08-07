class TattleController
  include Mack::Controller
  
  def set_tell
    tell[:notice] = params[:say]
    render(:action, :read_tell)
  end
  
  def set_tell_and_redirect
    tell[:notice] = params[:say]
    redirect_to(read_tell_url)
  end
  
  def read_tell
  end
  
end
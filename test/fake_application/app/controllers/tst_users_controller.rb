class TstUsersController
  include Mack::Controller
  
  def index
    render(:text, "tst_users: index")
  end
  
  def show
    render(:text, "tst_users: show: id: #{params[:id]}")
  end
  
  def update
    render(:text, "tst_users: update: id: #{params[:id]}")
  end
  
  def delete
    render(:text, "tst_users: delete: id: #{params[:id]}")
  end
  
  def edit
    @user_id = params[:id]
  end
  
  def kill_kenny_good
    render(:text, kill_kenny)
  end
  
end
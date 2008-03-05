class TstUsersController < Mack::Controller::Base
  
  def index
    "tst_users: index"
  end
  
  def show
    "tst_users: show: id: #{params(:id)}"
  end
  
  def update
    "tst_users: update: id: #{params(:id)}"
  end
  
  def delete
    "tst_users: delete: id: #{params(:id)}"
  end
  
  def edit
    @user_id = params(:id)
  end
  
  def kill_kenny_good
    kill_kenny
  end
  
end
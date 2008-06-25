class Admin::UsersController
  include Mack::Controller
  def index
    render(:text, "Hello from Admin::UsersController")
  end
  
end
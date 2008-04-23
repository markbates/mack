class Admin::UsersController < Mack::Controller::Base
  
  def index
    render(:text => "Hello from Admin::UsersController")
  end
  
end
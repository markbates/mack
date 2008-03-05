class TstResourcesController < Mack::Controller::Base
  
  layout :my_cool
  
  def index
    "tst_resources: index"
  end
  
  def show
    "tst_resources: show: id: #{params(:id)}"
  end
  
  def update
    "tst_resources: update: id: #{params(:id)}"
  end
  
  def delete
    "tst_resources: delete: id: #{params(:id)}"
  end
  
  def create
    "tst_resources: create"
  end
  
  def new
    "tst_resources: new"
  end
  
  def edit
    @res_id = params(:id)
  end
  
end
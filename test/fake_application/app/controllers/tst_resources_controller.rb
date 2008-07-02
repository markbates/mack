class TstResourcesController
  include Mack::Controller
  
  layout :my_cool
  
  def index
    render(:text, "tst_resources: index")
  end
  
  def show
    render(:text, "tst_resources: show: id: #{params[:id]}")
  end
  
  def update
    render(:text, "tst_resources: update: id: #{params[:id]}")
  end
  
  def delete
    render(:text, "tst_resources: delete: id: #{params[:id]}")
  end
  
  def create
    render(:text, "tst_resources: create")
  end
  
  def new
    render(:text, "tst_resources: new")
  end
  
  def edit
    @res_id = params[:id]
  end
  
end
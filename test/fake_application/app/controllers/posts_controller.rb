class PostsController < Mack::Controller::Base
  
  # GET /posts
  def index
    @posts = Post.find(:all)
  end
  
  # GET /posts/1
  def show
    @post = Post.find(params(:id))
  end
  
  # GET /posts/new
  def new
    @post = Post.new
  end
  
  # GET /posts/1/edit
  def edit
    @post = Post.find(params(:id))
  end
  
  # POST /posts
  def create
    @post = Post.new(params(:post))
    if @post.save
      redirect_to(posts_show_url(:id => @post))
    else
      render(:action => "new")
    end
  end
  
  # PUT /posts/1
  def update
    @post = Post.find(params(:id))
    if @post.update_attributes(params(:post))
      redirect_to(posts_show_url(:id => @post))
    else
      render(:action => "edit")
    end
  end

  # DELETE /posts/1
  def delete
    @post = Post.find(params(:id))
    @post.destroy!
    redirect_to(posts_index_url)
  end
  
end

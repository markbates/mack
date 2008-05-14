class TstHomePageController < Mack::Controller::Base

  def index
    "tst_home_page: <%= 'index' %>"
  end
  
  def foo
    @pickles = "yummy"
    @time = Time.now
  end
  
  def hello_world
    "Hello World"
  end
  
  def world_hello
    redirect_to(hello_world_url)
  end
  
  def yahoo
    redirect_to("http://www.yahoo.com", :status => 301)
  end
  
  def server_side_world_hello
    redirect_to(hello_world_url, :server_side => true)
  end
  
  def read_session_id_cookie
    "session_id: #{cookies[Mack::Configuration[:session_id]]}"
  end
  
  def read_param_from_session
    t = session[:my_time]
    if t.nil?
      session[:my_time] = Time.now
      t = session[:my_time]
    end
    "time from session: #{t}"
  end
  
  def read_cookie
    "cookies[:bourne]: #{cookies[:bourne]}"
  end
  
  def write_cookie
    cookies[:bourne] = (params(:bourne) || "Jason Bourne Rocks! #{Time.now}")
    redirect_to("/tst_home_page/read_cookie")
  end
  
  def write_two_cookies
    cookies[:bourne] = (params(:bourne) || "Jason Bourne Rocks! #{Time.now}")
    cookies[:woody] = (params(:woody) || "Woody Allen's Funny! #{Time.now}")
    redirect_to("/tst_home_page/read_cookie")
  end
  
  def hello_from_render_text
    render(:text, "hello")
  end
  
  def foo_from_render_action
    render(:action, :foo)
    @pickles = "rock!!"
    @time = Time.now
  end
  
  def blow_from_bad_render_action
    render(:action, :i_dont_exist)
  end
  
  def blow_up_from_double_render
    render(:text, "text to render...")
    render(:action, :foo)
  end
  
  def hello_world_url_test
    hello_world_url
  end
  
  def hello_world_url_test_in_view
  end
  
  def named_route_full_url
    hello_world_full_url
  end
  
  def request_full_host
    request.full_host
  end
  
  def request_full_host_with_port
    request.full_host_with_port
  end
  
end
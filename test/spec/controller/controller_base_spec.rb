require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

class WantsTestController < Mack::Controller::Base
  def you_want_what
    wants(:html) do
      render(:text, "<html>Hello World</html>")
    end
    wants(:xml) do
      render(:text, "<xml><greeting>Hello World</greeting></xml>")
    end
  end
  
  def on_disk_wants
    @greeting = "Hello World"
  end
  
  def ren_xml
    @greeting = "Hello World"
    render(:xml, :on_disk_wants)
  end
  
  def wants_404
    render(:template, '/application/404', :status => 404)
  end
end


describe "Base Controller" do
  # include Assertions
  
  before(:all) do
    puts "building routes"
    Mack::Routes.build do |r|
      r.you_want_what "/yww", :controller => "wants_test", :action => :you_want_what
      r.on_disk_wants "/odw", :controller => "wants_test", :action => :on_disk_wants
      r.ren_xml "/ren_xml", :controller => "wants_test", :action => :ren_xml, :format => :xml
      r.on_disk_wants_x "/odw_x", :controller => "wants_test", :action => :on_disk_wants, :format => :xml
      r.wants_unknown "/wants_404", :controller => "wants_test", :action => :wants_404
    end
  end
  
  it "should handle admin_index" do
    get admin_users_index_url
    response.body.should match(/Hello from Admin::UsersController/)
  end
  
  it "should handle request with format" do
    get on_disk_wants_x_url
    response.body.should match(/<greeting>Hello World<\/greeting>/)
    response.body.should_not match(/<html>/)
  end
  
  it "should render 404" do
    get wants_unknown_url
    response.body.should match(/404!/)
    assert_response(:not_found)
  end
  
  it "should render xml" do
    get ren_xml_url
    response.body.should match(/<greeting>Hello World<\/greeting>/)
    response.body.should_not match(/<html>/)
  end
  
  it "should render on-disk wants" do
    get on_disk_wants_url
    assigns(:greeting).should_not be_nil
    response.body.should match(/<p>Hello World<\/p>/)
    
    get "/odw.html"
    response.body.should match(/<p>Hello World<\/p>/)
    response.body.should match(/<html>/)
    
    get "/odw.xml"
    response.body.should match(/<greeting>Hello World<\/greeting>/)
    response.body.should_not match(/<html>/)
  end
  
  it "should handle wants" do
    get you_want_what_url
    response.body.should match(/<html>Hello World<\/html>/)
    
    get "/yww.html"
    response.body.should match(/<html>Hello World<\/html>/)
    
    get "/yww.xml"
    response.body.should match(/<xml><greeting>Hello World<\/greeting><\/xml>/)
  end
  
  it "should automatically render an action" do
    get "/foo"
    response.body.should match(/tst_home_page: foo: yummy/)
  end
  
  it "should render text" do
    get "/hello_from_render_text"
    response.body.should match(/hello/)
  end
  
  it "should render action" do
    get "/foo_from_render_action"
    response.body.should match(/tst_home_page: foo: rock!!/)
  end
      
  it "should raise error if trying to render bad action" do
    lambda { get "/blow_from_bad_render_action" }.should raise_error(Mack::Errors::ResourceNotFound)
  end
  
  it "should raise error if trying to do double render" do
    lambda { get "/blow_up_from_double_render" }.should raise_error(Mack::Errors::DoubleRender)
  end
  
  it "should render content from disk if there's no action in controller" do
    get "/tst_another/no_action_in_cont_served_from_disk"
    response.body.should match(/hello from: no_action_in_cont_served_from_disk/)
  end
  
  it "should render contnet from public folder if no action in controller" do
    get "/tst_another/no_action_in_cont_served_from_public"
    assert_response :success
    response.body.should match(/hello from: no_action_in_cont_served_from_public/)
    # because it's being served from the public directory we shouldn't wrap a layout around it.
    # assert !response.body.match("<title>Application Layout</title>") 
  end
  
  it "should render from public folder if there's no controller associated with the action" do
    get "/something/hello"
    assert_response :success
    response.body.should match(/Hi from public\/something\/hello.html/)
  end 

  it "should raise error if there's no controller and no matching file in public" do
    lambda { get "/dflsjflsdjf/sadlfjsdlfjasldf/sdljsadlsdfl.html" }.should raise_error(Mack::Errors::ResourceNotFound)
  end
  
  it "should redirect" do
    get "/tst_home_page/world_hello"
    assert_response :redirect
    assert_response 302
    assert_redirected_to("/hello/world")
    response.body.should match(/Hello World/)
  end
   
  it "should handle external redirect" do
    get "/tst_home_page/yahoo"
    assert_response :redirect
    assert_response 301
    assert_redirected_to("http://www.yahoo.com")
  end
     
  it "should handle server-side redirect" do
    get "/tst_home_page/server_side_world_hello"
    assert_response :success
    response.body.should match(/Hello World/)
  end
end

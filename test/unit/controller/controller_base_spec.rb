require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

class WantsTestController
  include Mack::Controller
  
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


describe Mack::Controller do
  
  describe Mack::Controller::Registry do
    
    it "should hold a list of all the controllers registered with Mack" do
      class RegTestController
      end
      Mack::Controller::Registry.registered_items.should_not include(RegTestController)
      RegTestController.send(:include, Mack::Controller)
      Mack::Controller::Registry.registered_items.should include(RegTestController)
    end
    
  end
  
  before(:all) do
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
    response.should be_not_found
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
    response.should be_successful
    response.body.should match(/hello from: no_action_in_cont_served_from_public/)
  end
  
  it "should render from public folder if there's no controller associated with the action" do
    get "/something/hello"
    response.should be_successful
    response.body.should match(/Hi from public\/something\/hello.html/)
  end 

  it "should raise error if there's no controller and no matching file in public" do
    lambda { get "/dflsjflsdjf/sadlfjsdlfjasldf/sdljsadlsdfl.html" }.should raise_error(Mack::Errors::ResourceNotFound)
  end
  
  it "should redirect" do
    get "/tst_home_page/world_hello"
    response.should be_redirect
    response.status.should == 302
    response.should be_redirected_to("/hello/world")
    response.body.should match(/Hello World/)
  end
   
  it "should handle external redirect" do
    get "/tst_home_page/yahoo"
    response.should be_redirect
    response.status.should == 301
    response.should be_redirected_to("http://www.yahoo.com")
  end
     
  it "should handle server-side redirect" do
    get "/tst_home_page/server_side_world_hello"
    response.should be_successful
    response.body.should match(/Hello World/)
  end
  
end

require File.dirname(__FILE__) + '/../test_helper.rb'

class ControllerBaseTest < Test::Unit::TestCase
  
  class WantsTestController < Mack::Controller::Base
    def you_want_what
      wants(:html) do
        render(:text => "<html>Hello World</html>")
      end
      wants(:xml) do
        render(:text => "<xml><greeting>Hello World</greeting></xml>")
      end
    end
    
    def on_disk_wants
      @greeting = "Hello World"
    end
    
    def ren_xml
      @greeting = "Hello World"
      render(:xml => :on_disk_wants)
    end
    
  end
  
  Mack::Routes.build do |r|
    r.you_want_what "/yww", :controller => "controller_base_test/wants_test", :action => :you_want_what
    r.on_disk_wants "/odw", :controller => "controller_base_test/wants_test", :action => :on_disk_wants
    r.ren_xml "/ren_xml", :controller => "controller_base_test/wants_test", :action => :ren_xml
    r.on_disk_wants_x "/odw_x", :controller => "controller_base_test/wants_test", :action => :on_disk_wants, :format => :xml
  end
  
  def test_format_on_route_definition_sets_initial_format
    get on_disk_wants_x_url
    assert_match "<greeting>Hello World</greeting>", response.body
    assert !response.body.match("<html>")
  end
  
  def test_render_xml
    get ren_xml_url
    assert_match "<greeting>Hello World</greeting>", response.body
    assert !response.body.match("<html>")
  end
  
  def test_on_disk_wants
    get on_disk_wants_url
    assert_match "<p>Hello World</p>", response.body
    
    get "/odw.html"
    assert_match "<p>Hello World</p>", response.body
    assert_match "<html>", response.body
    
    get "/odw.xml"
    assert_match "<greeting>Hello World</greeting>", response.body
    assert !response.body.match("<html>")
  end
  
  def test_wants
    get you_want_what_url
    assert_match "<html>Hello World</html>", response.body
    
    get "/yww.html"
    assert_match "<html>Hello World</html>", response.body
    
    get "/yww.xml"
    assert_match "<xml><greeting>Hello World</greeting></xml>", response.body
  end
  
  def test_automatic_render_of_action
    get "/foo"
    assert_match "tst_home_page: foo: yummy", response.body
  end
  
  def test_render_text
    get "/hello_from_render_text"
    assert_match "hello", response.body
  end
  
  def test_render_action
    get "/foo_from_render_action"
    assert_match "tst_home_page: foo: rock!!", response.body
  end
  
  def test_blow_from_bad_render_action
    assert_raise(Errno::ENOENT) { get "/blow_from_bad_render_action" }
  end
  
  def test_blow_up_from_double_render
    assert_raise(Mack::Errors::DoubleRender) { get "/blow_up_from_double_render" }
  end
  
  def test_no_action_in_cont_served_from_disk
    get "/tst_another/no_action_in_cont_served_from_disk"
    assert_match "hello from: no_action_in_cont_served_from_disk", response.body
  end
  
  def test_no_action_in_cont_served_from_public
    get "/tst_another/no_action_in_cont_served_from_public"
    assert_response :success
    assert_match "hello from: no_action_in_cont_served_from_public", response.body
    # because it's being served from the public directory we shouldn't wrap a layout around it.
    # assert !response.body.match("<title>Application Layout</title>") 
  end
  
  def test_basic_redirect_to
    get "/tst_home_page/world_hello"
    assert_response :redirect
    assert_response 302
    assert_redirected_to("/hello/world")
    assert_match "Hello World", response.body
  end
  
  def test_external_redirect_to
    get "/tst_home_page/yahoo"
    assert_response :redirect
    assert_response 301
    assert_redirected_to("http://www.yahoo.com")
    # assert_match "<title>Yahoo!</title>", response.body
  end
  
  def test_server_side_redirect_to
    get "/tst_home_page/server_side_world_hello"
    assert_response :success
    assert_match "Hello World", response.body
  end
  
end
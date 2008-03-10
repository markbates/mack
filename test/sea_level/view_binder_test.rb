require File.dirname(__FILE__) + '/../test_helper.rb'

class ViewBinderTest < Test::Unit::TestCase
  
  class RenderUrlController < Mack::Controller::Base
    
    def good_local_render_url
      render(:url => "http://testing.mackframework.com/hello_world.html")
    end
    
    def bad_local_render_url
      render(:url => "http://testing.mackframework.com/i_dont_exist.html")
    end
    
    def bad_local_render_with_raise_url
      render(:url => "http://testing.mackframework.com/i_dont_exist.html", :raise_exception => true)
    end
    
  end
  
  Mack::Routes.build do |r|
    r.good_local_render "/good_local_render_url", :controller => "view_binder_test/render_url", :action => :good_local_render_url
    r.bad_local_render "/bad_local_render_url", :controller => "view_binder_test/render_url", :action => :bad_local_render_url
    r.bad_local_render_with_raise "/bad_local_render_with_raise_url", :controller => "view_binder_test/render_url", :action => :bad_local_render_with_raise_url
  end
  
  def test_render
    get "/tst_another/big_render"
    assert_match "<title>Application Layout</title>", response.body
    assert_match "<p>latest news</p>", response.body
    assert_match "/hello/world", response.body
    assert_match "<p>how to</p>", response.body
    assert_match "This Is My Inline Text!", response.body
  end
  
  def test_render_url
    remote_test do
      get good_local_render_url
      assert_match "Hello World", response.body
      get bad_local_render_url
      assert_equal "", response.body
      assert_raise(Mack::Errors::UnsuccessfulRenderUrl) { get bad_local_render_with_raise_url }
    end
  end
  
  
end
require File.dirname(__FILE__) + '/../test_helper.rb'

class ViewBinderTest < Test::Unit::TestCase
  
  class RenderUrlController < Mack::Controller::Base
    
    def good_local_render_url
      render(:url => "http://testing.mackframework.com/render_url_get_test.php", :parameters => {:age => 31})
    end
    
    def bad_local_render_url
      render(:url => "http://testing.mackframework.com/i_dont_exist.html", :parameters => {:age => 31})
    end
    
    def bad_local_render_with_raise_url
      render(:url => "http://testing.mackframework.com/i_dont_exist.html", :raise_exception => true, :parameters => {:age => 31})
    end
    
    def good_post_local_render_url
      render(:url => "http://testing.mackframework.com/render_url_post_test.php", :method => :post, :parameters => {:age => 31})
    end
    
    def bad_post_local_render_url
      render(:url => "http://testing.mackframework.com/i_dont_exist.php", :method => :post, :parameters => {:age => 31})
    end
    
    def bad_post_local_render_with_raise_url
      render(:url => "http://testing.mackframework.com/i_dont_exist.php", :raise_exception => true, :method => :post, :parameters => {:age => 31})
    end
    
    def good_put_local_render_url
      render(:url => "http://testing.mackframework.com/render_url_post_test.php", :method => :put, :parameters => {:age => 31})
    end
    
    def good_delete_local_render_url
      render(:url => "http://testing.mackframework.com/render_url_post_test.php", :method => :delete, :parameters => {:age => 31})
    end
    
  end
  
  Mack::Routes.build do |r|
    # gets
    r.good_local_render "/good_local_render_url", :controller => "view_binder_test/render_url", :action => :good_local_render_url
    r.bad_local_render "/bad_local_render_url", :controller => "view_binder_test/render_url", :action => :bad_local_render_url
    r.bad_local_render_with_raise "/bad_local_render_with_raise_url", :controller => "view_binder_test/render_url", :action => :bad_local_render_with_raise_url
    
    # posts
    r.good_post_local_render "/good_post_local_render_url", :controller => "view_binder_test/render_url", :action => :good_post_local_render_url
    r.bad_post_local_render "/bad_post_local_render_url", :controller => "view_binder_test/render_url", :action => :bad_post_local_render_url
    r.bad_post_local_render_with_raise "/bad_post_local_render_with_raise_url", :controller => "view_binder_test/render_url", :action => :bad_post_local_render_with_raise_url
    
    # puts
    r.good_put_local_render "/good_put_local_render_url", :controller => "view_binder_test/render_url", :action => :good_put_local_render_url
    
    # deletes
    r.good_delete_local_render "/good_delete_local_render_url", :controller => "view_binder_test/render_url", :action => :good_delete_local_render_url
  end
  
  def test_render
    get "/tst_another/big_render"
    assert_match "<title>Application Layout</title>", response.body
    assert_match "<p>latest news</p>", response.body
    assert_match "/hello/world", response.body
    assert_match "<p>how to</p>", response.body
    assert_match "This Is My Inline Text!", response.body
  end
  
  def test_render_get_url
    remote_test do
      get good_local_render_url
      assert_match "age: 31", response.body
      get bad_local_render_url
      assert_equal "", response.body
      assert_raise(Mack::Errors::UnsuccessfulRenderUrl) { get bad_local_render_with_raise_url }
    end
  end
  
  def test_render_post_url
    remote_test do
      get good_post_local_render_url
      assert_match "age: 31", response.body
      get bad_post_local_render_url
      assert_equal "", response.body
      assert_raise(Mack::Errors::UnsuccessfulRenderUrl) { get bad_post_local_render_with_raise_url }
    end
  end
  
  
end
require File.dirname(__FILE__) + '/../test_helper.rb'

class ViewBinderTest < Test::Unit::TestCase
  
  class RenderUrlController < Mack::Controller::Base
    
    def good_local_render_url
      render(:url => "http://localhost:6666/foo")
    end
    
  end
  
  Mack::Routes.build do |r|
    r.good_local_render "/good_local_render_url", :controller => "view_binder_test/render_url", :action => :good_local_render_url
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
    Mack::Testing::Server.instance.register("/foo") do
      "Hello World!!"
    end
    # get good_local_render_url
    # pp response
    # assert_match "Hello World", response.body
    require 'net/http'
    res = Net::HTTP.get_response(URI.parse("http://0.0.0.0:6666/foo"))
    pp res
    res = Net::HTTP.get_response(URI.parse("http://0.0.0.0:6666/test"))
    pp res
  end
  
  
end
require File.dirname(__FILE__) + '/../test_helper.rb'

class ViewTemplateUrlTest < Test::Unit::TestCase
  
  def test_render_local_url
    assert_match(erb('<b><%= render(:url => "/vtt/say_hi", :raise_exception => true) %></b>'), "<b>Hello</b>")
  end
  
  def test_render_get_url
    remote_test do
      get good_url_get_url
      assert_match "age: 31", response.body
      get bad_url_get_url
      assert_equal "", response.body
      assert_raise(Mack::Errors::UnsuccessfulRenderUrl) { get bad_url_get_with_raise_url }
    end
  end
  
  def test_render_post_url
    remote_test do
      post good_url_post_url
      assert_match "age: 31", response.body
      post bad_url_post_url
      assert_equal "", response.body
      assert_raise(Mack::Errors::UnsuccessfulRenderUrl) { post bad_url_post_with_raise_url }
    end
  end
  
end
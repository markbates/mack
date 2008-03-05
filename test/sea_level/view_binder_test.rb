require File.dirname(__FILE__) + '/../test_helper.rb'

class ViewBinderTest < Test::Unit::TestCase
  
  def test_render
    get "/tst_another/big_render"
    assert_match "<title>Application Layout</title>", response.body
    assert_match "<p>latest news</p>", response.body
    assert_match "/hello/world", response.body
    assert_match "<p>how to</p>", response.body
    assert_match "This Is My Inline Text!", response.body
  end
  
  
end
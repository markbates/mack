require File.dirname(__FILE__) + '/../test_helper.rb'

class LayoutTest < Test::Unit::TestCase
  
  # no layout specified, use application
  def test_default_layout
    get hello_world_url
    assert_match "<title>Application Layout</title>", response.body
    assert_match "Hello World", response.body
  end
  
  # layout defined in controller with layout macro
  def test_controller_defined_level_layout
    get tst_resources_index_url
    assert_match "<title>My Cool Layout</title>", response.body
  end
  
  # layout set in render in action
  def test_action_defined_level_layout
    get "/tst_another/act_level_layout_test_action"
    assert_match "<title>My Super Cool Layout</title>", response.body
    assert_match "I've changed the layout in the action!", response.body
  end
  
  def test_nil_layout
    get "/tst_another/bar"
    assert_match "<title>Application Layout</title>", response.body
    
    get "/tst_another/layout_set_to_nil_in_action"
    assert_equal "I've set my layout to nil!", response.body
  end
  
  def test_false_layout
    get "/tst_another/bar"
    assert_match "<title>Application Layout</title>", response.body
    
    get "/tst_another/layout_set_to_false_in_action"
    assert_equal "I've set my layout to false!", response.body
  end
  
  def test_unknown_layout
    assert_raise(Mack::Errors::ResourceNotFound) { get "/tst_another/layout_set_to_unknown_in_action" }
  end
  
end
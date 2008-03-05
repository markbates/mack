require File.dirname(__FILE__) + '/../test_helper.rb'
class RouteMapTest < Test::Unit::TestCase
  
  def test_config_param_doesnt_exist_at_all
    assert_nil app_config.mack.lkajsdfljfsdaj
  end
  
  # def test_config_param_overridden
  #   assert_equal "error", app_config.mack.log_level
  # end
  
  def test_default_constants_overridden_correctly
    assert_equal true, app_config.mack.cache_classes
  end
  
end
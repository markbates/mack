require File.dirname(__FILE__) + '/../test_helper.rb'
class DistributedRouteTest < Test::Unit::TestCase
  
  def test_unknown_application_droute_url
    assert_raise(Mack::Distributed::Errors::UnknownApplication) { droute_url(:unknown_app, :foo_url) }
  end
  
  def test_unknown_route_name_droute_url
    assert_raise(Mack::Distributed::Errors::UnknownRouteName) { droute_url(:known_app, :unknown_url) }
  end
  
  def test_droute_url
    assert_equal "/my_known_app/my_known_url", droute_url(:known_app, :known_url)
  end
  
  def test_droute_url_with_options
    assert_equal "/my_known_app/my_known_url_w_opts/1", droute_url(:known_app, :known_url_w_opts, :id => 1)
  end
  
end
require File.dirname(__FILE__) + '/../../test_helper.rb'
class DistributedRouteTest < Test::Unit::TestCase
  
  def setup
    puts "setup"
    app_config.load_hash({"mack::use_distributed_routes" => true, "mack::distributed_app_name" => :known_app}, :distributed_route_test)
    # app_config.reload
    Mack::Routes.build do |r| # force the routes to go the DRb server
      r.known "/my_known_app/my_known_url", :controller => :foo, :action => :bar
      r.known_w_opts "/my_known_app/my_known_url_w_opts/:id", :controller => :foo, :action => :bar
    end
  end
  
  def teardown
    puts "teardown"
    app_config.revert
  end
  
  def test_unknown_application_droute_url
    puts "test_unknown_application_droute_url"
    assert_raise(Mack::Distributed::Errors::UnknownApplication) { droute_url(:unknown_app, :foo_url) }
  end
  
  def test_unknown_route_name_droute_url
    puts "test_unknown_route_name_droute_url"
    assert_raise(Mack::Distributed::Errors::UnknownRouteName) { droute_url(:known_app, :unknown_url) }
  end
  
  def test_droute_url
    puts "test_droute_url"
    assert_equal "#{app_config.mack.distributed_site_domain}/my_known_app/my_known_url", droute_url(:known_app, :known_url)
    assert_equal "#{app_config.mack.distributed_site_domain}/my_known_app/my_known_url", droute_url(:known_app, :known)
    assert_equal "#{app_config.mack.distributed_site_domain}/my_known_app/my_known_url", droute_url(:known_app, :known_distributed_url)
  end
  
  def test_droute_url_with_options
    puts "test_droute_url_with_options"
    assert_equal "#{app_config.mack.distributed_site_domain}/my_known_app/my_known_url_w_opts/1", droute_url(:known_app, :known_w_opts_url, :id => 1)
  end
  
  def test_nil_app_when_registering
    puts "test_nil_app_when_registering"
    temp_app_config("mack::distributed_app_name" => nil) do
      assert_raise(Mack::Distributed::Errors::ApplicationNameUndefined) { Mack::Routes.build {|r|} }
    end
  end
  
  def test_using_droute_url_when_not_configured_to_do_so
    puts "test_using_droute_url_when_not_configured_to_do_so"
    temp_app_config("mack::use_distributed_routes" => false) do
      assert_equal nil, droute_url(:known_app, :known_url)
    end
  end
  
end
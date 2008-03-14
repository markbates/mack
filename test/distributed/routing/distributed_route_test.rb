require File.dirname(__FILE__) + '/../../test_helper.rb'
class DistributedRouteTest < Test::Unit::TestCase
  
  def setup
    # fire up the drb server
    @started_drb_server = false
    t = Thread.new do
      x = `ps aux | grep cachetastic_drb_server`
      unless x.match(/\/cachetastic_drb_server/)
        `cachetastic_drb_server > /dev/null &`
        @started_drb_server = true
      end
    end
    t.join
    if @started_drb_server
      puts "sleep for a second to let the drb server fire up."
      sleep(1)
    end
    app_config.load_hash({"mack::use_distributed_routes" => true, "mack::distributed_app_name" => :known_app}, :distributed_route_test)
    app_config.reload
    Mack::Routes.build do |r| # force the routes to go the DRb server
      r.known "/my_known_app/my_known_url", :controller => :foo, :action => :bar
      r.known_w_opts "/my_known_app/my_known_url_w_opts/:id", :controller => :foo, :action => :bar
    end
  end
  
  def teardown
    # tear down the drb server
    x = `ps aux | grep cachetastic_drb_server`
    x.split("\n").each do |line|
      if line.match("/cachetastic_drb_server")
        pid = line.match(/\s(\d+)/).captures.first
        `kill -9 #{pid}`
      end
    end
    app_config.revert
  end
  
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
    assert_equal "/my_known_app/my_known_url_w_opts/1", droute_url(:known_app, :known_w_opts_url, :id => 1)
  end
  
end
require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe "D-Route" do
  
  before(:all) do
    begin
      DRb.start_service
      Rinda::RingServer.new(Rinda::TupleSpace.new)
      # DRb.thread.join
    rescue Errno::EADDRINUSE => e
      # it's fine to ignore this, it's expected that it's already running.
      # all other exceptions should be thrown
    end
    begin
      rs.take([:testing, :String, nil, nil], 0)
    rescue Exception => e
    end
    app_config.load_hash({"mack::use_distributed_routes" => true, "mack::distributed_app_name" => :known_app}, :distributed_route_test)
    Mack::Routes.build do |r| # force the routes to go the DRb server
      r.known "/my_known_app/my_known_url", :controller => :foo, :action => :bar
      r.known_w_opts "/my_known_app/my_known_url_w_opts/:id", :controller => :foo, :action => :bar
    end
  end
  
  after(:all) do
    app_config.revert
  end
  
  it "should raise error when unknown app url is requested" do
    lambda { droute_url(:unknown_app, :foo_url) }.should raise_error(Rinda::RequestExpiredError)
  end
  
  it "should raise error when unknown named route is requested" do
    lambda { droute_url(:known_app, :unknown_url) }.should raise_error(Mack::Distributed::Errors::UnknownRouteName)
  end
  
  it "should be able to resolve d-route url" do
    droute_url(:known_app, :known_url).should == "#{app_config.mack.distributed_site_domain}/my_known_app/my_known_url"
    droute_url(:known_app, :known).should == "#{app_config.mack.distributed_site_domain}/my_known_app/my_known_url"
    droute_url(:known_app, :known_distributed_url).should == "#{app_config.mack.distributed_site_domain}/my_known_app/my_known_url"
  end
  
  it "should be able to resolve d-route url with options" do
    droute_url(:known_app, :known_w_opts_url, :id => 1).should ==
               "#{app_config.mack.distributed_site_domain}/my_known_app/my_known_url_w_opts/1"
  end
  
  it "should raise error when registering a nil application" do
    temp_app_config("mack::distributed_app_name" => nil) do
      lambda { Mack::Routes.build {|r|} }.should raise_error(Mack::Distributed::Errors::ApplicationNameUndefined)
    end
  end
  
  it "should raise error when d-route is used when not configured as distributed route" do
    temp_app_config("mack::use_distributed_routes" => false) do
      droute_url(:known_app, :known_url).should be_nil
    end
  end
end 

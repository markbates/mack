require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

class UrlHelperTestSimpleObject
  
  attr_accessor :id
  attr_accessor :title
  
  def initialize(id, title)
    self.id = id
    self.title = title
  end
  
  def to_param
    "uhtso-#{id}-#{title.reverse}"
  end
  
end

describe Mack::Routes::Urls do
  
  before(:all) do
    Mack::Routes.build do |r|
      r.shoot_me_now '/please/shot/me/now', :controller => :default, :action => :index, :format => :gun
      r.host_me '/host/me', :host => 'www.mackframework.com'
      r.port_me '/port/me', :port => 8000
      r.scheme_me '/scheme/me', :scheme => 'https'
      r.host_port_me '/host/port/me', :host => 'www.mackframework.com', :port => 8080
      r.yahoo '/api', :host => 'www.yahoo.com', :scheme => 'http', :key => 12345
      r.beatles '/beatles/:action', :controller => :beatles
    end
  end
  
  describe 'url_for_pattern' do
    
    it 'should generate a url based on the options specified' do
      shoot_me_now_url.should == '/please/shot/me/now.gun'
    end
    
    it 'should build a full url if scheme and/or host is supplied' do
      @request = Mack::Request.new(Rack::MockRequest.env_for("http://example.org"))
      url_for_pattern("/:controller/:action", :controller => :users, :action => :show, :scheme => 'https').should == 'https://example.org/users/show'
      url_for_pattern("/:controller/:action", :controller => :users, :action => :show, :host => 'myexample.org').should == 'http://myexample.org/users/show'
      url_for_pattern("/:controller/:action", :controller => :users, :action => :show, :scheme => 'https', :host => 'myexample.org').should == 'https://myexample.org/users/show'
      url_for_pattern("/:controller/:action", :controller => :users, :action => :show, :scheme => 'https', :host => 'myexample.org', :port => 8080).should == 'https://myexample.org:8080/users/show'
      url_for_pattern("/:controller/:action", :controller => :users, :action => :show, :port => 8080).should == 'http://example.org:8080/users/show'
      url_for_pattern("/:controller/:action", :controller => :users, :action => :show).should == '/users/show'
    end
    
  end
  
  it 'should generate full urls with named routes' do
    @request = Mack::Request.new(Rack::MockRequest.env_for("http://example.org"))
    yahoo_url.should == 'http://www.yahoo.com/api?key=12345'
    yahoo_url(:key => 666).should == 'http://www.yahoo.com/api?key=666'
    beatles_url(:action => :john).should == '/beatles/john'
    host_me_url.should == 'http://www.mackframework.com/host/me'
    port_me_url.should == 'http://example.org:8000/port/me'
    scheme_me_url.should == 'https://example.org/scheme/me'
    host_port_me_url.should == 'http://www.mackframework.com:8080/host/port/me'
  end
  
  it "should handle url formatting" do
    tst_resources_index_url(:format => :xml).should == "/tst_resources.xml"
    tst_resources_index_url(:id => 1, :format => :xml).should == "/tst_resources.xml?id=1"
    tst_resources_index_url(:id => 2, :format => :xml).should == "/tst_resources.xml?id=2"
    tst_resources_index_url(:id => "1-hello-world", :format => :xml).should == "/tst_resources.xml?id=1-hello-world"
    tst_resources_index_url(:id => 1, :foo => :bar, :format => :xml).should == "/tst_resources.xml?foo=bar&id=1"
    tst_resources_index_url(:id => 2, :foo => :bar, :format => :xml).should == "/tst_resources.xml?foo=bar&id=2"
    tst_resources_index_url(:id => "1-hello-world", :foo => :bar, :format => :xml).should ==
                            "/tst_resources.xml?foo=bar&id=1-hello-world"
  end
  
  it "should be able to build params in url" do
    tst_resources_index_url(:id => UrlHelperTestSimpleObject.new(1, "hello")).should == "/tst_resources?id=uhtso-1-olleh"
  end
  
  it "should render url connected to controller" do
    get "/tst_home_page/hello_world_url_test"
    response.body.should match(/\/hello\/world/)
  end
  
  it "should render url connected directly to view" do
    get "/tst_home_page/hello_world_url_test_in_view"
    response.body.should match(/\/hello\/world/)
  end
    
  it "should handle escaped named_routes " do
    hello_world_url(:id => "Who's Your Daddy!?!").should == "/hello/world?id=Who%27s+Your+Daddy%21%3F%21"
  end

  it "should handle named_route" do
    get "/tst_home_page/named_route_full_url"
    response.body.should match(/http:\/\/example.org\/hello\/world/)
  end
  
  it "should handle index url" do
    tst_resources_index_url.should == "/tst_resources"
    tst_resources_index_url(:id => 1).should == "/tst_resources?id=1"
    tst_resources_index_url(:id => 2).should == "/tst_resources?id=2"
    tst_resources_index_url(:id => "1-hello-world").should == "/tst_resources?id=1-hello-world"
    tst_resources_index_url(:id => 1, :foo => :bar).should == "/tst_resources?foo=bar&id=1"
    tst_resources_index_url(:id => 2, :foo => :bar).should == "/tst_resources?foo=bar&id=2"
    tst_resources_index_url(:id => "1-hello-world", :foo => :bar).should == "/tst_resources?foo=bar&id=1-hello-world"
  end
  
  it "should handle show" do
    tst_resources_show_url(:id => 1).should == "/tst_resources/1"
    tst_resources_show_url(:id => 2).should == "/tst_resources/2"
    tst_resources_show_url(:id => "1-hello-world").should == "/tst_resources/1-hello-world"
  end
  
  it "should handle update" do
    tst_resources_update_url(:id => 1).should == "/tst_resources/1"
    tst_resources_update_url(:id => 2).should == "/tst_resources/2"
    tst_resources_update_url(:id => "1-hello-world").should == "/tst_resources/1-hello-world"
  end
   
  it "should handle delete" do
    tst_resources_delete_url(:id => 1).should == "/tst_resources/1"
    tst_resources_delete_url(:id => 2).should == "/tst_resources/2"
    tst_resources_delete_url(:id => "1-hello-world").should == "/tst_resources/1-hello-world"
  end
  
  it "should handle edit" do 
    tst_resources_edit_url(:id => 1).should == "/tst_resources/1/edit"
    tst_resources_edit_url(:id => 2).should == "/tst_resources/2/edit"
    tst_resources_edit_url(:id => "1-hello-world").should == "/tst_resources/1-hello-world/edit"
  end
  
  it "should handle create" do
    tst_resources_create_url.should == "/tst_resources"
    tst_resources_create_url(:id => 1).should == "/tst_resources?id=1"
    tst_resources_create_url(:id => 2).should == "/tst_resources?id=2"
    tst_resources_create_url(:id => "1-hello-world").should == "/tst_resources?id=1-hello-world"
    tst_resources_create_url(:id => 1, :foo => :bar).should == "/tst_resources?foo=bar&id=1"
    tst_resources_create_url(:id => 2, :foo => :bar).should == "/tst_resources?foo=bar&id=2"
    tst_resources_create_url(:id => "1-hello-world", :foo => :bar).should == "/tst_resources?foo=bar&id=1-hello-world"
  end
   
  it "should handle new" do
    tst_resources_new_url.should == "/tst_resources/new"
    tst_resources_new_url(:id => 1).should == "/tst_resources/new?id=1"
    tst_resources_new_url(:id => 2).should == "/tst_resources/new?id=2"
    tst_resources_new_url(:id => "1-hello-world").should == "/tst_resources/new?id=1-hello-world"
    tst_resources_new_url(:id => 1, :foo => :bar).should == "/tst_resources/new?foo=bar&id=1"
    tst_resources_new_url(:id => 2, :foo => :bar).should == "/tst_resources/new?foo=bar&id=2"
    tst_resources_new_url(:id => "1-hello-world", :foo => :bar).should == "/tst_resources/new?foo=bar&id=1-hello-world"
  end
  
end

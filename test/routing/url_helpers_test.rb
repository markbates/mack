require File.dirname(__FILE__) + '/../test_helper.rb'
class UrlHelpersTest < Test::Unit::TestCase
  
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
  
  def test_to_param
    assert_equal "/tst_resources?id=uhtso-1-olleh", tst_resources_index_url(:id => UrlHelperTestSimpleObject.new(1, "hello"))
  end
  
  def test_available_in_controllers
    get "/tst_home_page/hello_world_url_test"
    assert_match "/hello/world", response.body
  end
  
  def test_available_in_views
    get "/tst_home_page/hello_world_url_test_in_view"
    assert_match "/hello/world", response.body
  end
  
  def test_named_routes_are_escaped
    assert_equal "/hello/world?id=Who%27s+Your+Daddy%21%3F%21", hello_world_url(:id => "Who's Your Daddy!?!")
  end
  
  def test_named_route_full
    get "/tst_home_page/named_route_full_url"
    assert_match "http://example.org/hello/world", response.body
  end
  
  def test_index
    assert_equal "/tst_resources", tst_resources_index_url
    assert_equal "/tst_resources?id=1", tst_resources_index_url(:id => 1)
    assert_equal "/tst_resources?id=2", tst_resources_index_url(:id => 2)
    assert_equal "/tst_resources?id=1-hello-world", tst_resources_index_url(:id => "1-hello-world")
    assert_equal "/tst_resources?foo=bar&id=1", tst_resources_index_url(:id => 1, :foo => :bar)
    assert_equal "/tst_resources?foo=bar&id=2", tst_resources_index_url(:id => 2, :foo => :bar)
    assert_equal "/tst_resources?foo=bar&id=1-hello-world", tst_resources_index_url(:id => "1-hello-world", :foo => :bar)
  end
  
  def test_show
    assert_equal "/tst_resources/1", tst_resources_show_url(:id => 1)
    assert_equal "/tst_resources/2", tst_resources_show_url(:id => 2)
    assert_equal "/tst_resources/1-hello-world", tst_resources_show_url(:id => "1-hello-world")
  end
  
  def test_update
    assert_equal "/tst_resources/1/update", tst_resources_update_url(:id => 1)
    assert_equal "/tst_resources/2/update", tst_resources_update_url(:id => 2)
    assert_equal "/tst_resources/1-hello-world/update", tst_resources_update_url(:id => "1-hello-world")
  end
  
  def test_delete
    assert_equal "/tst_resources/1", tst_resources_delete_url(:id => 1)
    assert_equal "/tst_resources/2", tst_resources_delete_url(:id => 2)
    assert_equal "/tst_resources/1-hello-world", tst_resources_delete_url(:id => "1-hello-world")
  end
  
  def test_edit
    assert_equal "/tst_resources/1/edit", tst_resources_edit_url(:id => 1)
    assert_equal "/tst_resources/2/edit", tst_resources_edit_url(:id => 2)
    assert_equal "/tst_resources/1-hello-world/edit", tst_resources_edit_url(:id => "1-hello-world")
  end
  
  def test_create
    assert_equal "/tst_resources", tst_resources_create_url
    assert_equal "/tst_resources?id=1", tst_resources_create_url(:id => 1)
    assert_equal "/tst_resources?id=2", tst_resources_create_url(:id => 2)
    assert_equal "/tst_resources?id=1-hello-world", tst_resources_create_url(:id => "1-hello-world")
    assert_equal "/tst_resources?foo=bar&id=1", tst_resources_create_url(:id => 1, :foo => :bar)
    assert_equal "/tst_resources?foo=bar&id=2", tst_resources_create_url(:id => 2, :foo => :bar)
    assert_equal "/tst_resources?foo=bar&id=1-hello-world", tst_resources_create_url(:id => "1-hello-world", :foo => :bar)
  end
  
  def test_new
    assert_equal "/tst_resources/new", tst_resources_new_url
    assert_equal "/tst_resources/new?id=1", tst_resources_new_url(:id => 1)
    assert_equal "/tst_resources/new?id=2", tst_resources_new_url(:id => 2)
    assert_equal "/tst_resources/new?id=1-hello-world", tst_resources_new_url(:id => "1-hello-world")
    assert_equal "/tst_resources/new?foo=bar&id=1", tst_resources_new_url(:id => 1, :foo => :bar)
    assert_equal "/tst_resources/new?foo=bar&id=2", tst_resources_new_url(:id => 2, :foo => :bar)
    assert_equal "/tst_resources/new?foo=bar&id=1-hello-world", tst_resources_new_url(:id => "1-hello-world", :foo => :bar)
  end
  
end
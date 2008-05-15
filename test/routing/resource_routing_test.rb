require File.dirname(__FILE__) + '/../test_helper.rb'
class ResourceRoutingTest < Test::Unit::TestCase
  
  def test_index
    get "/tst_resources"
    assert_match "tst_resources: index", response.body
  end
  
  def test_show
    get "/tst_resources/1"
    assert_match "tst_resources: show: id: 1", response.body
  end
  
  def test_update
    assert_raise(Mack::Errors::ResourceNotFound) { get "/tst_resources/1/update"}
    put "/tst_resources/1"
    assert_match "tst_resources: update: id: 1", response.body
  end
  
  def test_delete
    get "/tst_resources/1"
    assert_match "tst_resources: show: id: 1", response.body
    
    delete "/tst_resources/1"
    assert_match "tst_resources: delete: id: 1", response.body
  end
  
  def test_edit
    get "/tst_resources/1/edit"
    assert_match "tst_resources: edit: id: 1", response.body
  end
  
  def test_create
    get "/tst_resources"
    assert_match "tst_resources: index", response.body
    
    post "/tst_resources"
    assert_match "tst_resources: create", response.body
  end
  
  def test_new
    get "/tst_resources/new"
    assert_match "tst_resources: new", response.body
  end
  
end
require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "Resource Routing" do

  it "should route to index" do
    get "/tst_resources"
    response.body.should match(/tst_resources: index/)
  end

  it "should route to show" do
    get "/tst_resources/1"
    response.body.should match(/tst_resources: show: id: 1/)
  end

  it "should route to update" do
    lambda { get "/tst_resources/1/update" }.should raise_error(Mack::Errors::ResourceNotFound)
    put "/tst_resources/1"
    response.body.should match(/tst_resources: update: id: 1/)
  end

  it "should route to delete" do
    get "/tst_resources/1"
    response.body.should match(/tst_resources: show: id: 1/)

    delete "/tst_resources/1"
    response.body.should match(/tst_resources: delete: id: 1/)
  end

  #   def test_edit
  #     get "/tst_resources/1/edit"
  #     assert_match "tst_resources: edit: id: 1", response.body
  #   end

  it "should route to edit" do
    get "/tst_resources/1/edit"
    response.body.should match(/tst_resources: edit: id: 1/)
  end

  it "should route to create" do
    get "/tst_resources"
    response.body.should match(/tst_resources: index/)
    
    post "/tst_resources"
    response.body.should match(/tst_resources: create/)
  end
   
  it "should route to new" do
    get "/tst_resources/new"
    response.body.should match(/tst_resources: new/)
  end
  
end

require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "render(:url)" do
  include CommonHelpers
  
  it "should render local url" do
    template = '<b><%= render(:url, "/vtt/say_hi", :raise_exception => true) %></b>'
    erb(template).should == "<b>Hello</b>"
  end
  
  it "should render get url" do
    remote_test do
      get good_url_get_url
      response.body.should match(/age: 31/)
      get bad_url_get_url
      response.body.should == ""
      check_exception(Mack::Errors::UnsuccessfulRenderUrl) { get bad_url_get_with_raise_url }
    end
  end
  
  it "should render post url" do 
    remote_test do
      post good_url_post_url
      response.body.should match(/age: 31/)
      post bad_url_post_url
      response.body.should == "" 
      check_exception(Mack::Errors::UnsuccessfulRenderUrl) { post bad_url_post_with_raise_url }
    end
  end
end

require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

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
      lambda { get bad_url_get_with_raise_url }.should raise_error(Mack::Errors::UnsuccessfulRenderUrl)
    end
  end
  
  it "should render post url" do 
    remote_test do
      post good_url_post_url
      response.body.should match(/age: 31/)
      post bad_url_post_url
      response.body.should == "" 
      lambda { post bad_url_post_with_raise_url }.should raise_error(Mack::Errors::UnsuccessfulRenderUrl)
    end
  end
  
end

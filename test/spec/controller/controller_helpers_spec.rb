require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "Controller Helpers" do

  it "url-helper should works in correct controller" do
    get kill_kenny_good_url
    response.body.should match(/You killed Kenny!/)
  end
  
  it "url-helper should raise error when accessed directly because it's not public" do
    lambda { get kill_kenny_no_meth_url }.should raise_error(Mack::Errors::ResourceNotFound)
  end
  
  it "url-helper should raise error when wrong used in wrong controller" do
    lambda { get kill_kenny_bad_url }.should raise_error(NameError)
  end
  
  it "application-helper should be included everywhere" do
    get "/foo"
    response.body.should match(/love you/)
    
    get "/tst_resources/1/edit"
    response.body.should match(/love you/)
    
    get "/tst_another/say_love_you"
    response.body.should match(/love you/)
  end

end

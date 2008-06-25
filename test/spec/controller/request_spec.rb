require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "Request" do
  
  it "should handle request to full host" do
    get "/tst_home_page/request_full_host"
    response.body.should match(/http:\/\/example.org/)
  end
  
  it "should handle request to full host with port" do
    get "/tst_home_page/request_full_host_with_port"
    response.body.should match(/http:\/\/example.org:80/)
  end
  
  it "should handle request session" do
    in_session do
      get "/tst_home_page/read_param_from_session"
      session.should_not be_nil
      t = session[:my_time]
      t.should_not be_nil
      response.body.should match(/#{t.strftime("%m/%d/%Y %H:%M:%S")}/)
      sleep(1)
      get "/tst_home_page/read_param_from_session"
      session.should_not be_nil
      session[:my_time].to_s.should == t.to_s
    end
  end
  
  it "should handle params accessed regardless as string or symbol" do
    get "/tst_another/regardless_of_string_or_symbol?foo=bar"
    response.body.should match(/from_string: foo=bar/)
    response.body.should match(/from_symbol: foo=bar/)
  end
  
  it "should return nested params as hash" do
    post "/tst_another/params_return_as_hash", :foo => {:one => "one", :two => "too", :three => 3}
    response.body.should match(/class: Hash/)
    foo = assigns(:foo)
    foo.should_not be_nil
  end
  
end

require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::Request do
  
  it "should set Content-Length to response header" do
    get "/tst_home_page/request_full_host"
    response["Content-Length"].should_not be_nil
    response["Content-Length"].should == response.body.to_str.size.to_s
  end
  
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
  
  describe Mack::Request::Parameters do
    
    describe "to_s" do
      
      it "should filter out stuff on the Mack::Logging::Filter list" do
        params = Mack::Request::Parameters.new
        params[:foo] = 'f"o"o'
        params[:password] = "123456"
        params[:user] = {:password_confirmation => "123456"}
        params.to_s.should match(/:user=>{:password_confirmation=>"<FILTERED>"/)
        params.to_s.should match(/:password=>"<FILTERED>"/)
        params.to_s.should match(/:foo=>"f\\"o\\"o"/)
      end
      
      it "should work" do
        get "/tst_another/show_all_params?password=123456&foo=fubar"
        f = ':foo=>"fubar"'
        response.body.should match(/#{f}/)
        p = ':password=>"<FILTERED>"'
        response.body.should match(/#{p}/)
      end 
      
    end
    
  end
  
end

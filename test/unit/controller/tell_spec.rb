require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::Controller::Tell do
  include Mack::Controller::Tell
  
  it "should be settable in a controller and readable in a view" do
    session[:tell].should be_nil
    get set_tell_url(:say => "hello good looking")
    response.should be_successful
    response.body.should match(/Someone wanted to say: 'hello good looking'/)
    session[:tell].should be_nil
  end
  
  it "should be persist through a redirect" do
    session[:tell].should be_nil
    get set_tell_and_redirect_url(:say => "what up?")
    response.should be_redirect
    response.should be_redirected_to(read_tell_url)
    response.body.should match(/Someone wanted to say: 'what up\?'/)
    session[:tell].should be_nil
  end
  
  it "should get set to an empty Hash in the Session if it's nil" do
    session[:tell].should be_nil
    tell[:notice] = "hello"
    session[:tell].should_not be_nil
    tell[:notice].should == "hello"
    session[:tell][:notice].should == "hello"
  end
  
end
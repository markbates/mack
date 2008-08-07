require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::Controller::Tell do
  include Mack::Controller::Tell
  
  it "should be settable in a controller"
  
  it "should be readable in a view"
  
  it "should persist until the next non-redirected action"
  
  it "should behave like a Hash"
  
  it "should get set to an empty Hash in the Session if it's nil" do
    session[:tell].should be_nil
    tell[:notice] = "hello"
    session[:tell].should_not be_nil
    tell[:notice].should == "hello"
    session[:tell][:notice].should == "hello"
  end
  
end
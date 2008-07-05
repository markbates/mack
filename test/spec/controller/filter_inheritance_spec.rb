require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

class TopController
  include Mack::Controller
  
  before_filter :say_hi
  protected
  def say_hi
    @hello = "hi from TopController"
  end
end

class MiddleController < TopController
  before_filter :say_something
  protected
  def say_something
    @something = "something from MiddleController"
  end
end

class BottomController < MiddleController
  before_filter :say_bye
  def bf_index
    render(:text, "i'm in the bottom controller")
  end
  protected
  def say_bye
    @bye = "bye from BottomController"
  end
end

describe "Mack::Controller::Filter Inheritance" do
  
  before(:all) do
    Mack::Routes.build do |r|
      r.bottom_bf_index "/bottom_bf_index", :controller => "bottom", :action => :bf_index
    end
  end
  
  it "should handle basic filter inheritance" do
    filters = []
    filters << Mack::Controller::Filter.new(:say_hi, ::TopController, {})
    filters << Mack::Controller::Filter.new(:say_something, ::MiddleController, {})
    filters << Mack::Controller::Filter.new(:say_bye, ::BottomController, {})
    BottomController.controller_filters[:before].should == filters
  end
  
  it "should handle before_filter inheritance" do
    get bottom_bf_index_url
    response.body.should match(/i'm in the bottom controller/)
    
    hello = assigns(:hello)
    hello.should_not be_nil
    hello.should == "hi from TopController"
    
    something = assigns(:something)
    something.should_not be_nil
    something.should == "something from MiddleController"
    
    bye = assigns(:bye)
    bye.should_not be_nil
    bye.should == "bye from BottomController"
  end
  
end


require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::Session do
  
  describe "reset!" do
    
    it "should clear the session out" do
      session[:user_id] = 1
      session[:user_id].should == 1
      session.reset!
      session[:user_id].should be_nil
    end
    
  end
  
end
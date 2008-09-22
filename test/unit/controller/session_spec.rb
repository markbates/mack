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
  
  describe "configatron.mack.use_sessions" do
    
    class SessionSpecController
      include Mack::Controller
      
      def index
        session[:id] = params[:id] if session[:id].nil?
        render(:text, "id: #{session[:id]}")
      end
      
    end
    
    it "should be able to turn off sessions" do
      temp_app_config(:mack => {:use_sessions => false}) do
        lambda{get "/session_spec/index"}.should raise_error(Mack::Errors::NoSessionError)
      end
    end
    
    it "should be able to turn on sessions (default)" do
      get "/session_spec/index?id=1"
      response.body.should match(/id: 1/)
      get "/session_spec/index"
      response.body.should match(/id: 1/)
      get "/session_spec/index?id=2"
      response.body.should match(/id: 1/)
    end
    
  end
  
end
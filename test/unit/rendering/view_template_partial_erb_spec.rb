require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe "render(:partial)" do
  
  describe "erb" do
    
    it "should be able to handle outside partial" do
      get partial_outside_url
      response.body.should == "Hi from the outside partial"
    end
  
    it "should be able to handle local partial" do
      get partial_local_url
      response.body.should == "Hi from the local partial"
    end
    
  end
  
end
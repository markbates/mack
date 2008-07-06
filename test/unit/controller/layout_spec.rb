require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe "Layout" do
  
  it "should use default layout" do
    get hello_world_url
    response.body.should match(//)
    response.body.should match(/<title>Application Layout<\/title>/)
  end
  
  it "should handle the case where layout is defined in controller with layout macro" do
    get tst_resources_index_url
    response.body.should match(/<title>My Cool Layout<\/title>/)
  end
  
  it "should handle the case where layout set in render in action" do
    get "/tst_another/act_level_layout_test_action"
    response.body.should match(/<title>My Super Cool Layout<\/title>/)
    response.body.should match(/I've changed the layout in the action!/)
  end
  
  it "should handle nil layout" do
    get "/tst_another/bar"
    response.body.should match(/<title>Application Layout<\/title>/)
    
    get "/tst_another/layout_set_to_nil_in_action"
    response.body.should match(/I've set my layout to nil!/)
  end
  
  it "should handle false layout" do
    get "/tst_another/bar"
    response.body.should match(/<title>Application Layout<\/title>/)
    
    get "/tst_another/layout_set_to_false_in_action"
    response.body.should == "I've set my layout to false!"
  end
  
  it "should handle unknown layout" do
    get "/tst_another/layout_set_to_unknown_in_action"
    response.body.should == "I've set my layout to some layout that don't exist!"
  end
  
end

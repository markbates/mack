# require File.dirname(__FILE__) + '/../test_helper.rb'
# 
# class ViewTemplatePartialErbTest < Test::Unit::TestCase
#   
#   def test_partial_outside
#     get partial_outside_url
#     assert_equal "Hi from the outside partial", response.body
#   end
#   
#   def test_partial_local
#     get partial_local_url
#     assert_equal "Hi from the local partial", response.body
#   end
#   
# end

require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "render(:partial)" do
  describe "ERB" do
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
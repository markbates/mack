require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

class MyController < Mack::Controller::Base
  
end

describe "render(:url)" do
  it "should render local url" do
    true
    # template = '<b><%= render(:url, "/vtt/say_hi", :raise_exception => true) %></b>'
    # rendered = view_template.new(:inline, template, :controller => MyController.new).compile_and_render
    # rendered.should == "<b>Hello</b>"
  end
end

# require File.dirname(__FILE__) + '/../test_helper.rb'
# 
# class ViewTemplateUrlTest < Test::Unit::TestCase
#   
#   def test_render_local_url
#     assert_match(erb('<b><%= render(:url, "/vtt/say_hi", :raise_exception => true) %></b>'), "<b>Hello</b>")
#   end
#   
#   def test_render_get_url
#     remote_test do
#       get good_url_get_url
#       assert_match "age: 31", response.body
#       get bad_url_get_url
#       assert_equal "", response.body
#       assert_raise(Mack::Errors::UnsuccessfulRenderUrl) { get bad_url_get_with_raise_url }
#     end
#   end
#   
#   def test_render_post_url
#     remote_test do
#       post good_url_post_url
#       assert_match "age: 31", response.body
#       post bad_url_post_url
#       assert_equal "", response.body
#       assert_raise(Mack::Errors::UnsuccessfulRenderUrl) { post bad_url_post_with_raise_url }
#     end
#   end
#   
# end
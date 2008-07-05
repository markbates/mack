require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "render(:action)" do
  
  describe "erb" do
    
    include ContentValidationHelper
    
    before(:all) do
      @base_dir = File.dirname(__FILE__)
    end
    
    it "should render with a default layout" do
      get bart_html_erb_with_layout_url
      validate_content_and_type(@base_dir, "action_erb_default_layout.txt")
    end

    it "should render with a special layout if told to do so" do
      get bart_html_erb_with_special_layout_url
      validate_content_and_type(@base_dir, "action_erb_special_layout.txt")
    end

    it "should render with no layout if told to do so" do
      get bart_html_erb_without_layout_url
      response.body.should == "Bart Simpson: HTML, ERB\n"
    end

  end # erb
    
end
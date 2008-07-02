require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "render(:inline)" do
  
  describe "erb" do
    
    include ContentValidationHelper
    
    before(:all) do
      @base_dir = File.dirname(__FILE__)
    end
    
    it "should render with a default layout" do
      get lisa_inline_erb_with_layout_url
      validate_content_and_type(@base_dir, "inline_with_default_layout.txt")
    end

    it "should render with a special layout if told to do so" do
      get lisa_inline_erb_with_special_layout_url
      validate_content_and_type(@base_dir, "inline_with_special_layout.txt")
    end

    it "should render with no layout if told to do so" do
      get lisa_inline_erb_without_layout_url
      validate_content_and_type(@base_dir, "inline_with_no_layout.txt")
    end

  end # erb
  
end # "render(:inline)"
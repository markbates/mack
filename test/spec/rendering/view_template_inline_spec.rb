require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

module RenderInlineHelper  
  def validate_content(file_name)
    body = File.read(File.join(File.dirname(__FILE__), "contents", file_name))
    response.body.should == body
  end
  
end

describe "render(:inline)" do
  
  describe "erb" do
    
    include RenderInlineHelper
    
    it "should render with a default layout" do
      get lisa_inline_erb_with_layout_url
      validate_content("inline_with_default_layout.txt")
    end

    it "should render with a special layout if told to do so" do
      get lisa_inline_erb_with_special_layout_url
      validate_content("inline_with_special_layout.txt")
    end

    it "should render with no layout if told to do so" do
      get lisa_inline_erb_without_layout_url
      validate_content("inline_with_no_layout.txt")
    end

  end # erb
  
end # "render(:inline)"
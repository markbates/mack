require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

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
    
    it "should report errors correctly" do
      get broken_erb_url
      message = assigns(:message)
      backtrace = assigns(:backtrace)
      message.should == 'ILikeToBreak'
      backtrace.first.should_not match('lib/mack/rendering/view_template.rb')
      backtrace.first.should match('views/vtt/view_template/broken.html.erb')
    end

  end # erb
    
end
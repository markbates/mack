require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "render(:xml)" do
  
  include ContentValidationHelper
  
  before(:all) do
    @base_dir = File.dirname(__FILE__)
  end
  
  it "should be able to render with layout" do
    get homer_xml_with_layout_url
    validate_content_and_type(@base_dir, "xml_with_layout.txt", :xml)
  end

  it "should be able to render with special layout" do
    get homer_xml_with_special_layout_url
    validate_content_and_type(@base_dir, "xml_with_special_layout.txt", :xml)
  end
  
  it "should be able to render with layout URL" do
    get homer_xml_without_layout_url
    validate_content_and_type(@base_dir, "xml_without_layout.txt", :xml)
  end
  
end


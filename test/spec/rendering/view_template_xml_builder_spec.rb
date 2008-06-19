require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

module XMLBuilderHelper
  def validate_content(file_name)
    body = File.read(File.join(File.dirname(__FILE__), "contents", file_name))
    response.body.should == body
    response["Content-Type"].should == "application/xml; text/xml"
  end 
end

describe "render(:xml)" do
  
  include XMLBuilderHelper
  
  it "should be able to render with layout" do
    get homer_xml_with_layout_url
    validate_content("xml_with_layout.txt")
  end

  it "should be able to render with special layout" do
    get homer_xml_with_special_layout_url
    validate_content("xml_with_special_layout.txt")
  end
  
  it "should be able to render with layout URL" do
    get homer_xml_without_layout_url
    validate_content("xml_without_layout.txt")
  end
end


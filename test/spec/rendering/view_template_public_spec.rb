require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "render(:public)" do
  include CommonHelpers
  
  it "should render file from public if it exists" do
    get public_found_url
    response.body.should == "<b>hello from /public/vtt_public_test.html</b>"
  end
  
  it "should raise error if request is to file that doesn't exists" do
    lambda { get public_not_found_url }.should raise_error(Mack::Errors::ResourceNotFound)
  end
  
  it "should find nested url" do
    get public_found_nested_url
    response.body.should == "<b>hello from /public/vtt/vtt_public_nested_test.html</b>"
  end
  
  it "should render public file with extension" do
    get public_with_extension_url
    response.body == "hello from /public/vtt/vtt_public_with_extension_test.txt"
  end
  
end

require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe "File Upload Request" do
  it "should handle multipart content properly" do
    post upload_file_url, :multipart => true, :file0 => build_file(File.join(File.dirname(__FILE__), "images", "homer_brain.jpg"))
    pp response
  end
end
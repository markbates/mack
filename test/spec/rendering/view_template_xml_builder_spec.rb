require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "render(:xml)" do
  it "should be able to render with layout" do
    get homer_xml_with_layout_url
    body = <<-EOF
<app>
  <?xml version="1.0" encoding="UTF-8"?>
<name>Homer Simpson</name>

</app>
EOF
    response.body.should == body.strip
    response["Content-Type"].should == "application/xml; text/xml"
  end

  it "should be able to render with special layout" do
    get homer_xml_with_special_layout_url
    body = <<-EOF
<my_cool>
  <?xml version="1.0" encoding="UTF-8"?>
<name>Homer Simpson</name>

</my_cool>
EOF
    response.body.should == body.strip
    response["Content-Type"].should == "application/xml; text/xml"
  end
  
  it "should be able to render with layout URL" do
    get homer_xml_without_layout_url
    response.body.should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<name>Homer Simpson</name>\n"
    response["Content-Type"].should == "application/xml; text/xml"
  end
end


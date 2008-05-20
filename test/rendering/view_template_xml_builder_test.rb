require File.dirname(__FILE__) + '/../test_helper.rb'

class ViewTemplateXmlBuilderTest < Test::Unit::TestCase
  
  def test_xml_with_layout
    get homer_xml_with_layout_url
    body = <<-EOF
<app>
  <?xml version="1.0" encoding="UTF-8"?>
<name>Homer Simpson</name>

</app>
EOF
    assert_equal body.strip, response.body
    assert_equal "application/xml; text/xml", response["Content-Type"]
  end

  def test_xml_with_special_layout
    get homer_xml_with_special_layout_url
    body = <<-EOF
<my_cool>
  <?xml version="1.0" encoding="UTF-8"?>
<name>Homer Simpson</name>

</my_cool>
EOF
    assert_equal body.strip, response.body
    assert_equal "application/xml; text/xml", response["Content-Type"]
  end

  def test_xml_with_layout_url
    get homer_xml_without_layout_url
    assert_equal "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<name>Homer Simpson</name>\n", response.body
    assert_equal "application/xml; text/xml", response["Content-Type"]
  end
  
end
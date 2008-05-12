require File.dirname(__FILE__) + '/../test_helper.rb'

class ViewTemplateTest < Test::Unit::TestCase
  
  def test_action_html_erb_with_layout
    get bart_html_erb_with_layout_url
    body = <<-EOF
<html>
  <head>
    <title>Bart's Page!</title>
  </head>
  <body>
    Bart Simpson: HTML, ERB

  </body>
</html>
EOF
    assert_equal body.strip, response.body
  end
  
  def test_action_html_erb_with_special_layout
    get bart_html_erb_with_special_layout_url
    body = <<-EOF
<html>
  <head>
    <title>My Cool Layout</title>
  </head>
  <body>
    Bart Simpson: HTML, ERB

  </body>
</html>
EOF
    assert_equal body.strip, response.body
  end
  
  def test_action_html_erb_with_layout_url
    get bart_html_erb_without_layout_url
    assert_equal "Bart Simpson: HTML, ERB\n", response.body
  end
  
  def test_text_erb_with_layout
    get lisa_text_erb_with_layout_url
    body = <<-EOF
<html>
  <head>
    <title>Application Layout</title>
  </head>
  <body>
    Lisa Simpson: TEXT, ERB
  </body>
</html>
EOF
    assert_equal body.strip, response.body
  end

  def test_text_erb_with_special_layout
    get lisa_text_erb_with_special_layout_url
    body = <<-EOF
<html>
  <head>
    <title>My Cool Layout</title>
  </head>
  <body>
    Lisa Simpson: TEXT, ERB
  </body>
</html>
EOF
    assert_equal body.strip, response.body
  end

  def test_text_erb_with_layout_url
    get lisa_text_erb_without_layout_url
    assert_equal "Lisa Simpson: TEXT, ERB", response.body
  end
  
  def test_xml_with_layout
    get homer_xml_with_layout_url
    body = <<-EOF
<app>
  <?xml version="1.0" encoding="UTF-8"?>
<name>Homer Simpson</name>

</app>
EOF
    assert_equal body.strip, response.body
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
  end

  def test_xml_with_layout_url
    get homer_xml_without_layout_url
    assert_equal "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<name>Homer Simpson</name>\n", response.body
  end
  
end
require File.dirname(__FILE__) + '/../test_helper.rb'

class ViewTemplateActionHamlTest < Test::Unit::TestCase
  
  def test_action_html_haml_with_layout
    get maggie_html_haml_with_layout_url
    body = <<-EOF
<html>
  <head>
    <title>Application Layout</title>
  </head>
  <body>
    <div id='name'>Maggie Simpson</div>
<div id='type'>HTML, HAML</div>

  </body>
</html>
EOF
    assert_equal body.strip, response.body
  end
  
  def test_action_html_haml_with_special_layout
    get maggie_html_haml_with_special_layout_url
    body = <<-EOF
<html>
  <head>
    <title>My Cool Layout</title>
  </head>
  <body>
    <div id='name'>Maggie Simpson</div>
<div id='type'>HTML, HAML</div>

  </body>
</html>
EOF
    assert_equal body.strip, response.body
  end
  
  def test_action_html_haml_with_layout_url
    get maggie_html_haml_without_layout_url
    assert_equal "<div id='name'>Maggie Simpson</div>\n<div id='type'>HTML, HAML</div>\n", response.body
  end
  
end
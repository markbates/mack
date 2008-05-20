require File.dirname(__FILE__) + '/../test_helper.rb'

class ViewTemplateActionMarkabyTest < Test::Unit::TestCase
  
  def test_action_html_markaby_with_layout
    get marge_html_markaby_with_layout_url
    body = <<-EOF
<html>
  <head>
    <title>Application Layout</title>
  </head>
  <body>
    <div><h1>Marge Simpson</h1><h2>HTML, MARKABY</h2></div>
  </body>
</html>
EOF
    assert_equal body.strip, response.body
  end
  
  def test_action_html_markaby_with_special_layout
    get marge_html_markaby_with_special_layout_url
    body = <<-EOF
<html>
  <head>
    <title>My Cool Layout</title>
  </head>
  <body>
    <div><h1>Marge Simpson</h1><h2>HTML, MARKABY</h2></div>
  </body>
</html>
EOF
    assert_equal body.strip, response.body
  end
  
  def test_action_html_markaby_with_layout_url
    get marge_html_markaby_without_layout_url
    assert_equal "<div><h1>Marge Simpson</h1><h2>HTML, MARKABY</h2></div>", response.body
  end
  
end
require File.dirname(__FILE__) + '/../test_helper.rb'

class ViewTemplateActionErbTest < Test::Unit::TestCase
  
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
  
end
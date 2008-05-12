require File.dirname(__FILE__) + '/../test_helper.rb'

class ViewTemplateTextErbTest < Test::Unit::TestCase
  
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
  
end
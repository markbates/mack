require File.dirname(__FILE__) + '/../test_helper.rb'

class ViewTemplateInlineErbTest < Test::Unit::TestCase
  
  def test_inline_erb_with_layout
    get lisa_inline_erb_with_layout_url
    body = <<-EOF
<html>
  <head>
    <title>Application Layout</title>
  </head>
  <body>
    Lisa Simpson: INLINE, ERB
  </body>
</html>
EOF
    assert_equal body.strip, response.body
  end

  def test_inline_erb_with_special_layout
    get lisa_inline_erb_with_special_layout_url
    body = <<-EOF
<html>
  <head>
    <title>My Cool Layout</title>
  </head>
  <body>
    Lisa Simpson: INLINE, ERB
  </body>
</html>
EOF
    assert_equal body.strip, response.body
  end

  def test_inline_erb_with_layout_url
    get lisa_inline_erb_without_layout_url
    assert_equal "Lisa Simpson: INLINE, ERB", response.body
  end
  
end
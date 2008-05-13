require File.dirname(__FILE__) + '/../test_helper.rb'

class ViewTemplatePublicTest < Test::Unit::TestCase
  
  def test_public_found
    get public_found_url
    assert_equal "<b>hello from /public/vtt_public_test.html</b>", response.body
  end
  
  def test_public_not_found
    assert_raise(Mack::Errors::ResourceNotFound) { get public_not_found_url }
  end
  
  def test_public_found_nested
    get public_found_nested_url
    assert_equal "<b>hello from /public/vtt/vtt_public_nested_test.html</b>", response.body
  end
  
end
require File.dirname(__FILE__) + '/../../../test_helper.rb'

class StringHelpersTest < Test::Unit::TestCase
  
  include Mack::ViewHelpers::StringHelpers
  
  def test_pluralize_word
    assert_equal "1 error", pluralize_word(1, "error")
    assert_equal "2 errors", pluralize_word(2, "error")
    assert_equal "0 errors", pluralize_word(0, "error")
    assert_equal "1 error", pluralize_word(1, "errors")
    assert_equal "2 errors", pluralize_word(2, "errors")
    assert_equal "0 errors", pluralize_word(0, "errors")
  end
  
end
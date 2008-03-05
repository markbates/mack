require File.dirname(__FILE__) + '/../test_helper.rb'

class NilTest < Test::Unit::TestCase
  
  def test_blank
    assert nil.blank? 
  end
  
end
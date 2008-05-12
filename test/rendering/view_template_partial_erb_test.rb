require File.dirname(__FILE__) + '/../test_helper.rb'

class ViewTemplatePartialErbTest < Test::Unit::TestCase
  
  def test_partial_outside
    get partial_outside_url
    assert_equal "Hi from the outside partial", response.body
  end
  
  def test_partial_local
    get partial_local_url
    assert_equal "Hi from the local partial", response.body
  end
  
end
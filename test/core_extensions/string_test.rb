require File.dirname(__FILE__) + '/../test_helper.rb'

class StringTest < Test::Unit::TestCase

  def test_encrypt_decrypt
    encypted_value = "hello world".encrypt
    assert encypted_value != "hello world"
    assert_equal "hello world", encypted_value.decrypt
  end
  
end
require File.dirname(__FILE__) + '/../test_helper.rb'

class KernelTest < Test::Unit::TestCase
  
  def test_encrypt
    assert_equal "dlrow olleh", _encrypt("hello world", :reverse)
  end
  
  def test_decrypt
    assert_equal "hello world", _decrypt("dlrow olleh", :reverse)
  end
  
end
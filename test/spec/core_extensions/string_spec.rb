require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "String Extensions" do
  
  describe "=> Encryption Engine" do
    it "should be able to encrypt/decrypt string" do
      raw_value = "hello world"
      encrypted_value = raw_value.encrypt
      encrypted_value.should_not == raw_value
      raw_value.should == encrypted_value.decrypt
    end
  end
  
end

# require File.dirname(__FILE__) + '/../test_helper.rb'
# 
# class StringTest < Test::Unit::TestCase
# 
#   def test_encrypt_decrypt
#     encypted_value = "hello world".encrypt
#     assert encypted_value != "hello world"
#     assert_equal "hello world", encypted_value.decrypt
#   end
#   
# end
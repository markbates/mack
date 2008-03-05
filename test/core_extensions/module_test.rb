require File.dirname(__FILE__) + '/../test_helper.rb'

class ModuleTest < Test::Unit::TestCase
  
  module ConvertMyMethodsPlease
    def foo
    end
    
    def bar
    end
  end
  
  module IncludeMeSafelyPlease
    def foo
    end
    
    def bar
    end
  end
  
  class LikeToBeSafe
  end
  
  def test_convert_security_of_methods 
    assert ConvertMyMethodsPlease.public_instance_methods.include?("foo")
    assert ConvertMyMethodsPlease.public_instance_methods.include?("bar")
    ConvertMyMethodsPlease.convert_security_of_methods
    assert !ConvertMyMethodsPlease.public_instance_methods.include?("foo")
    assert !ConvertMyMethodsPlease.public_instance_methods.include?("bar")
    assert ConvertMyMethodsPlease.protected_instance_methods.include?("foo")
    assert ConvertMyMethodsPlease.protected_instance_methods.include?("bar")
    ConvertMyMethodsPlease.convert_security_of_methods(:protected, :private)
    assert !ConvertMyMethodsPlease.protected_instance_methods.include?("foo")
    assert !ConvertMyMethodsPlease.protected_instance_methods.include?("bar")
    assert ConvertMyMethodsPlease.private_instance_methods.include?("foo")
    assert ConvertMyMethodsPlease.private_instance_methods.include?("bar")
  end
  
  def test_include_safely_into
    assert IncludeMeSafelyPlease.public_instance_methods.include?("foo")
    assert IncludeMeSafelyPlease.public_instance_methods.include?("bar")
    assert !LikeToBeSafe.public_instance_methods.include?("foo")
    assert !LikeToBeSafe.public_instance_methods.include?("bar")
    IncludeMeSafelyPlease.include_safely_into(LikeToBeSafe)
    assert !LikeToBeSafe.public_instance_methods.include?("foo")
    assert !LikeToBeSafe.public_instance_methods.include?("bar")
    assert LikeToBeSafe.protected_instance_methods.include?("foo")
    assert LikeToBeSafe.protected_instance_methods.include?("bar")
  end
  
end
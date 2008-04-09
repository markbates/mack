require File.dirname(__FILE__) + '/../../test_helper.rb'

class BaseGeneratorTest < Test::Unit::TestCase
  
  class SimpleGenerator < Mack::Generator::Base
    require_param :name
    require_param :id
    
    def generate
      directory(File.join(MACK_ROOT, "test", "simple_gen"))
    end
    
  end
  
  class BadGenerator < Mack::Generator::Base
  end
  
  def setup
    if File.exists?(File.join(MACK_ROOT, "test", "simple_gen"))
      FileUtils.rm_r(File.join(MACK_ROOT, "test", "simple_gen"))
    end
  end
  
  def teardown
    if File.exists?(File.join(MACK_ROOT, "test", "simple_gen"))
      FileUtils.rm_r(File.join(MACK_ROOT, "test", "simple_gen"))
    end
  end
  
  def test_require_param
    assert_raise(Mack::Errors::RequiredGeneratorParameterMissing) { SimpleGenerator.new }
    assert_raise(Mack::Errors::RequiredGeneratorParameterMissing) { SimpleGenerator.new("name" => :foo) }
    assert_raise(Mack::Errors::RequiredGeneratorParameterMissing) { SimpleGenerator.new("id" => 1) }
    sg = SimpleGenerator.new("name" => :foo, "id" => 1)
    assert_not_nil sg
    assert_equal 1, sg.param(:id)
    assert_equal :foo, sg.param(:name)
  end
  
  def test_run
    bg = BadGenerator.new
    assert_raise(MethodNotImplemented) { bg.run }
    assert_raise(MethodNotImplemented) { bg.generate }
  end
  
  def test_directory
    assert !File.exists?(File.join(MACK_ROOT, "test", "simple_gen"))
    sg = SimpleGenerator.new("name" => :foo, "id" => 1)
    sg.run
    assert File.exists?(File.join(MACK_ROOT, "test", "simple_gen"))
    # run it again to prove we don't get any errors if the folder already exists
    sg.run
    assert File.exists?(File.join(MACK_ROOT, "test", "simple_gen"))
  end
  
end
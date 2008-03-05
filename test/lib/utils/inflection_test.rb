require File.dirname(__FILE__) + '/../../test_helper.rb'

class InflectionTest < Test::Unit::TestCase
  
  def test_pluralize
    assert_equal "sheep", inflect.pluralize("sheep")
    assert_equal "boats", inflect.pluralize("boat")
    assert_equal "girls", inflect.pluralize("girl")
    assert_equal "armies", inflect.pluralize("army")
    assert_equal "people", inflect.pluralize("person")
    assert_equal "equipment", inflect.pluralize("equipment")
  end
  
  def test_singularize
    assert_equal "sheep", inflect.singularize("sheep")
    assert_equal "boat", inflect.singularize("boats")
    assert_equal "girl", inflect.singularize("girls")
    assert_equal "army", inflect.singularize("armies")
    assert_equal "person", inflect.singularize("people")
    assert_equal "equipment", inflect.singularize("equipment")
  end
  
  def test_uncountable
    assert_equal "equipment", inflect.singularize("equipment")
    assert_equal "equipment", inflect.pluralize("equipment")
  end
  
  def inflect
    Mack::Utils::Inflector.instance
  end
  
end
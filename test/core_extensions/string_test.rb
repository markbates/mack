require File.dirname(__FILE__) + '/../test_helper.rb'

class StringTest < Test::Unit::TestCase

  def test_camelcase
    assert_equal "User", "user".camelcase
    assert_equal "MyBlog", "my_blog".camelcase
    assert_equal "My::Blog", "my/blog".camelcase
  end
  
  def test_constantize
    assert_equal StringTest, "StringTest".constantize
  end
  
  def test_blank
    assert "".blank?
    assert nil.blank? 
  end
  
  def test_pluralize
    assert_equal "sheep", "sheep".plural
    assert_equal "boats", "boat".plural
    assert_equal "girls", "girl".plural
    assert_equal "armies", "army".plural
    assert_equal "people", "person".plural
    assert_equal "equipment", "equipment".plural
  end
  
  def test_singularize
    assert_equal "sheep", "sheep".singular
    assert_equal "boat", "boats".singular
    assert_equal "girl", "girls".singular
    assert_equal "army", "armies".singular
    assert_equal "person", "people".singular
    assert_equal "equipment", "equipment".singular
  end
  
end
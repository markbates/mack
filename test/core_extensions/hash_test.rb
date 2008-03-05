require File.dirname(__FILE__) + '/../test_helper.rb'

class NilTest < Test::Unit::TestCase
  
  def test_minus
    h = {:a => "aaa", :b => "bbb", :c => "ccc"}
    assert_equal({:b => "bbb", :c => "ccc"}, (h - :a))
    
    h = {:a => "aaa", :b => "bbb", :c => "ccc"}
    assert_equal({:b => "bbb", :c => "ccc"}, (h - [:a]))
    
    h = {:a => "aaa", :b => "bbb", :c => "ccc"}
    assert_equal({:c => "ccc"}, (h - [:a, :b]))
    
    h = {:a => "aaa", :b => "bbb", :c => "ccc"}
    assert_equal({:a => "aaa", :b => "bbb", :c => "ccc"}, (h - [:d, :e]))
    
    h = {:a => "aaa", :b => "bbb", :c => "ccc"}
    assert_equal({:a => "aaa", :b => "bbb", :c => "ccc"}, (h - :d))
  end
  
end
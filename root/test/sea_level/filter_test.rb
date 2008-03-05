require File.dirname(__FILE__) + '/../test_helper.rb'

class FilterTest < Test::Unit::TestCase
  
  def test_run
    f = Mack::Controller::Filter.new(:log_action)
    assert f.run?(:my_action)
    
    f = Mack::Controller::Filter.new(:log_action, :only => :my_action)
    assert f.run?(:my_action)
    assert !f.run?(:my_other_action)
    
    f = Mack::Controller::Filter.new(:log_action, :except => :my_action)
    assert !f.run?(:my_action)
    assert f.run?(:my_other_action)
    
    f = Mack::Controller::Filter.new(:log_action, :only => [:my_action, :my_other_action])
    assert f.run?(:my_action)
    assert f.run?(:my_other_action)
    assert !f.run?(:some_other_action)
    
    f = Mack::Controller::Filter.new(:log_action, :except => [:my_action, :my_other_action])
    assert !f.run?(:my_action)
    assert !f.run?(:my_other_action)
    assert f.run?(:some_other_action)
  end
  
  def test_before_all_actions
    get "/tst_my_filters/index"
    assert_match "Date: TODAY!", response.body
  end
  
  def test_before_simple_only
    get "/tst_my_filters/index"
    assert_match "Hi: ''", response.body
    
    get "/tst_my_filters/hello"
    assert_match "Hi: 'HELLO!!'", response.body
  end
  
  def test_before_simple_except
    get "/tst_my_filters/index"
    assert_match "Goodbye: 'bye!'", response.body
    
    get "/tst_my_filters/hello"
    assert_match "Goodbye: ''", response.body
  end
  
  def test_exception_raised_if_false_filter
    assert_raise(Mack::Errors::FilterChainHalted) { get "/tst_my_filters/please_blow_up" }
  end
  
  def test_after_fitler_simple_only
    get "/tst_my_filters/me"
    assert_match "'ME'", response.body
  end
  
  def test_after_render_filter_simple_only
    get "/tst_my_filters/make_all_a"
    assert_match "aaa", response.body
  end
  
  
end
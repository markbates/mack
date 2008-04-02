require File.dirname(__FILE__) + '/../test_helper.rb'

class FilterInheritanceTest < Test::Unit::TestCase
  
  class TopController < Mack::Controller::Base
    before_filter :say_hi
    protected
    def say_hi
      @hello = "hi from TopController"
    end
  end
  
  class MiddleController < TopController
    before_filter :say_something
    protected
    def say_something
      @something = "something from MiddleController"
    end
  end
  
  class BottomController < MiddleController
    before_filter :say_bye
    def bf_index
      render(:text => "i'm in the bottom controller")
    end
    protected
    def say_bye
      @bye = "bye from BottomController"
    end
  end
  
  Mack::Routes.build do |r|
    r.bottom_bf_index "/bottom_bf_index", :controller => "filter_inheritance_test/bottom", :action => :bf_index
  end
  
  def test_inheritance
    filters = []
    filters << Mack::Controller::Filter.new(:say_hi, FilterInheritanceTest::TopController, {})
    filters << Mack::Controller::Filter.new(:say_something, FilterInheritanceTest::MiddleController, {})
    filters << Mack::Controller::Filter.new(:say_bye, FilterInheritanceTest::BottomController, {})
    assert_equal filters, BottomController.controller_filters[:before]
  end
  
  def test_before_filter_inheritance
    get bottom_bf_index_url
    assert_match "i'm in the bottom controller", response.body
    
    hello = assigns(:hello)
    assert_not_nil hello
    assert_equal "hi from TopController", hello
    
    something = assigns(:something)
    assert_not_nil something
    assert_equal "something from MiddleController", something
    
    bye = assigns(:bye)
    assert_not_nil bye
    assert_equal "bye from BottomController", bye
  end
  
end
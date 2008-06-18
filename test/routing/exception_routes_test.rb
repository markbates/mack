require File.dirname(__FILE__) + '/../test_helper.rb'
class ExceptionRoutesTest < Test::Unit::TestCase
  
  class HellError < StandardError
    def initialize(x = "Oh Hell!!")
      super(x)
    end
  end
  
  class DrunkError < StandardError
  end
  
  class ExceptForMeController < Mack::Controller::Base
    
    def raise_hell
      raise HellError.new
    end
    
    def raise_drunk
      raise DrunkError.new
    end
    
  end
  
  class HandleErrorsController < Mack::Controller::Base
    
    def handle_hell_errors
      render(:text, "We're sorry for your hell: #{caught_exception.message}", :layout => false, :status => 500)
    end
    
  end
  
  Mack::Routes.build do |r|
    r.raise_hell "/except_for_me/raise_hell", :controller => "exception_routes_test/except_for_me", :action => :raise_hell
    r.raise_drunk "/except_for_me/raise_drunk", :controller => "exception_routes_test/except_for_me", :action => :raise_drunk
    r.handle_error ExceptionRoutesTest::HellError, :controller => "exception_routes_test/handle_errors", :action => :handle_hell_errors
  end
  
  def test_a_raised_exception_is_caught_and_handled
    get raise_hell_url
    assert_equal "We're sorry for your hell: Oh Hell!!", response.body
    assert_response :error
  end
  
  def test_a_raised_exception_is_not_caught_if_its_not_supposed_to
    assert_raise(ExceptionRoutesTest::DrunkError) { get raise_drunk_url }
  end
  
end
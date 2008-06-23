require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

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


describe "Routes Exceptions" do
  include Assertions
  
  before(:all) do
    Mack::Routes.build do |r|
      r.raise_hell "/except_for_me/raise_hell", :controller => "except_for_me", :action => :raise_hell
      r.raise_drunk "/except_for_me/raise_drunk", :controller => "except_for_me", :action => :raise_drunk
      r.handle_error ::HellError, :controller => "handle_errors", :action => :handle_hell_errors
    end
  end
  
  it "should catch and handle a raised exception" do
    get raise_hell_url
    response.body.should == "We're sorry for your hell: Oh Hell!!"
    assert_response :error
  end
  
  it "should not catch and handle a raised exception if it's not supposed to" do
    lambda { get raise_drunk_url }.should raise_error(DrunkError)
  end
end

# require File.dirname(__FILE__) + '/../test_helper.rb'
# class ExceptionRoutesTest < Test::Unit::TestCase
#   
#   
#   
#   def test_a_raised_exception_is_caught_and_handled
#     get raise_hell_url
#     assert_equal , response.body
#     assert_response :error
#   end
#   
#   def test_a_raised_exception_is_not_caught_if_its_not_supposed_to
#     assert_raise(ExceptionRoutesTest::DrunkError) 
#   end
#   
# end
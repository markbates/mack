require 'test/unit'
module Mack
  
  module TestAssertions
    
    # Takes either a Symbol or a Fixnum and assert the response matches it.
    # The symbols it will match are :success, :redirect, :not_found, :error.
    # If a Fixnum is passed it will assert the response status equals that Fixnum
    def assert_response(status)
      if status.is_a?(Symbol)
        case status
        when :success
          assert(responses.first.successful?)
        when :redirect
          assert(responses.first.redirect?)
        when :not_found
          assert(responses.first.not_found?)
        when :error
          assert(responses.first.server_error?)
        else
          assert(false)
        end
      elsif status.is_a?(Fixnum)
        assert_equal(status, responses.first.status)
      end
    end
    
    # Asserts that the request has been redirected to the specified url.
    def assert_redirected_to(url)
      assert_equal(url, responses.first.location)
    end
    
    # Asserts that the specified cookie has been set to the specified value.
    def assert_cookie(name, value)
      assert cookies[name.to_s]
    end
    
    # Asserts that there is no cookie set for the specified cookie
    def assert_no_cookie(name)
      assert !cookies[name.to_s]
    end
    
  end # TestAssertions
  
end # Mack

Test::Unit::TestCase.send(:include, Mack::TestAssertions)
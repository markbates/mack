require 'test/unit'
module Mack
  module Testing
    module TestCaseAssertions
    
      # Takes either a Symbol or a Fixnum and assert the response matches it.
      # The symbols it will match are :success, :redirect, :not_found, :error.
      # If a Fixnum is passed it will assert the response status equals that Fixnum
      def assert_response(status)
        if status.is_a?(Symbol)
          case status
          when :success
            assert(response.successful?)
          when :redirect
            assert(response.redirect?)
          when :not_found
            assert(response.not_found?)
          when :error
            assert(response.server_error?)
          else
            assert(false)
          end
        elsif status.is_a?(Fixnum)
          assert_equal(status, response.status)
        end
      end
    
      # Asserts that the request has been redirected to the specified url.
      def assert_redirected_to(url)
        assert response.redirected_to?(url)
      end
    
      # Asserts that the specified cookie has been set to the specified value.
      def assert_cookie(name, value)
        assert cookies[name.to_s]
        assert_equal value, cookies[name.to_s]
      end
    
      # Asserts that there is no cookie set for the specified cookie
      def assert_no_cookie(name)
        assert !cookies[name.to_s]
      end
    
      def assert_difference(object, method = nil, difference = 1)
        start_count = object.send(method)
        yield
        object.reload if object.respond_to? :reload
        assert_equal start_count + difference, object.send(method)
      end
    
    end # TestAssertions
  end # Testing
end # Mack

Test::Unit::TestCase.send(:include, Mack::Testing::TestCaseAssertions)
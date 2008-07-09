require File.join(File.dirname(__FILE__), "helpers")

module Mack
  module Testing
    module RSpecAssertions

      # Asserts that the request has been redirected to the specified url.
      def assert_redirected_to(url)
        responses.first.location.should == url
      end

      # Asserts that the specified cookie has been set to the specified value.
      def assert_cookie(name, value)
        cookies[name.to_s].should_not be_nil
        cookies[name.to_s].should == value
      end

      # Asserts that there is no cookie set for the specified cookie
      def assert_no_cookie(name)
        cookies[name.to_s].should be_nil
      end
    end # RSpecAssertions
  end # Testing
end # Mack

module Spec
  module Example
    module ExampleMethods
      include Mack::Routes::Urls
      # include Mack::Testing::Helpers
      # include Mack::Testing::RSpecAssertions
    end
  end
end

if Object.const_defined?("Spec")
  # include Mack::Routes::Urls
  include Mack::Testing::Helpers
  include Mack::Testing::RSpecAssertions
end
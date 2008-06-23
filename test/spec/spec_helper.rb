require 'rubygems'
gem 'rspec'
require 'spec'

require 'rake'
require 'fileutils'
ENV["_mack_env"] = "test"
ENV["_mack_root"] = File.join(File.dirname(__FILE__), "..", "fake_application")

if $genosaurus_output_directory.nil?
  $genosaurus_output_directory = ENV["_mack_root"]
  puts "$genosaurus_output_directory: #{$genosaurus_output_directory}"
end

# load the mack framework:
require(File.join(File.dirname(__FILE__), "..", "..", "lib", 'mack'))

# not quite sure why, but when you run rake you need to keep reloading the routes. this doesn't seem
# to be a problem when running script/server or when running an individual test.
require(File.join(File.dirname(__FILE__), "..",  "fake_application", "config", "routes.rb"))

self.send(:include, Mack::Routes::Urls)
self.send(:include, Mack::TestHelpers)

#-------------- HELPER MODULES --------------------------#

module CommonHelpers
  
  # TODO: find out how to get away from using mock***
  class MockCookieJar
    def all
      {}
    end
  end
  
  class MockSession
    def id
      1
    end
  end
  
  class MockRequest
    def env
      {}
    end
    def session
      MockSession.new
    end
  end
  
  class MockController
    def params(key)
      @params[key.to_sym]
    end
    def initialize(options = {})
      @params = {:format => "html"}.merge(options)
    end
    def cookies
      MockCookieJar.new
    end
    def request
      MockRequest.new
    end
  end
  
  def erb(template)
    Mack::Rendering::ViewTemplate.new(:inline, template, :controller => MockController.new).compile_and_render
  end
  
  def view_template
    Mack::Rendering::ViewTemplate
  end

end

module Assertions
  include CommonHelpers
  
  # Takes either a Symbol or a Fixnum and assert the response matches it.
  # The symbols it will match are :success, :redirect, :not_found, :error.
  # If a Fixnum is passed it will assert the response status equals that Fixnum
  def assert_response(status)
    if status.is_a?(Symbol)
      case status
      when :success
        responses.first.should be_successful
      when :redirect
        responses.first.should be_redirect
      when :not_found
        responses.first.should_not be_found
      when :error
        responses.first.should be_server_error
      else
        false.should == true
      end
    elsif status.is_a?(Fixnum)
      response.first.status.should == status
    end
  end
  
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
end
require 'rubygems'
gem 'rspec'
require 'spec'

require 'rake'
require 'fileutils'
ENV["_mack_env"] = "test"
ENV["MACK_ENV"] = ENV["_mack_env"]
ENV["_mack_root"] = File.join(File.dirname(__FILE__), "fake_application")
ENV["MACK_ROOT"] = ENV["_mack_root"]

if $genosaurus_output_directory.nil?
  $genosaurus_output_directory = ENV["_mack_root"]
  puts "$genosaurus_output_directory: #{$genosaurus_output_directory}"
end

# load the mack framework:
require(File.join(File.dirname(__FILE__), "..", "lib", 'mack'))

# not quite sure why, but when you run rake you need to keep reloading the routes. this doesn't seem
# to be a problem when running script/server or when running an individual test.
require(File.join(File.dirname(__FILE__), "fake_application", "config", "routes.rb"))

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
    def params
      @params
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

module ContentValidationHelper
  
  def validate_content(directory, file_name)
    body = File.read(File.join(directory, "contents", file_name))
    response.body.should == body
  end
  
  def validate_content_and_type(directory, file_name, content_type = :html)
    validate_content(directory, file_name)
    response["Content-Type"].should == case content_type
      when :xml: "application/xml; text/xml"
      when :html: "text/html"
      #... add more content type here when needed
    end
  end
  
end
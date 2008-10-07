require 'rubygems'
gem 'rspec'
require 'spec'

require 'rake'
require 'fileutils'
ENV["MACK_ENV"] = "test"
ENV["MACK_ROOT"] = File.join(File.dirname(__FILE__), "fake_application")

if $genosaurus_output_directory.nil?
  $genosaurus_output_directory = ENV["MACK_ROOT"]
  puts "$genosaurus_output_directory: #{$genosaurus_output_directory}"
end

# load the mack framework:
require(File.join(File.dirname(__FILE__), "..", "lib", 'mack'))


#-------------- HELPER MODULES --------------------------#

def fixture(name)
  File.read(File.join(File.dirname(__FILE__), "fixtures", "#{name}.fixture"))
end


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
    Mack::Rendering::ViewTemplate.new(:inline, template, :controller => MockController.new)._compile_and_render
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
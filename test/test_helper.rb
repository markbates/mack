require 'rubygems'
require "test/unit"
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

# not quite sure why, but when you run rake you need to keep reloading the routes. this doesn't seem
# to be a problem when running script/server or when running an individual test.
require(File.join(File.dirname(__FILE__),  "fake_application", "config", "routes.rb"))


# place common methods, assertions, and other type things in this file so
# other tests will have access to them.

module Mack
  module Utils
    module Crypt
      class ReverseWorker
        
        def encrypt(x)
          x.reverse
        end
        
        def decrypt(x)
          x.reverse
        end
        
      end
    end
  end
end

class Test::Unit::TestCase
  
  def use_data_mapper
    temp_app_config("orm" => "data_mapper") do
      load(File.join(File.dirname(__FILE__), "..", "lib", "initialization", "initializers", "orm_support.rb"))
      yield
    end
  end
  
  def use_active_record
    temp_app_config("orm" => "active_record") do
      load(File.join(File.dirname(__FILE__), "..", "lib", "initialization", "initializers", "orm_support.rb"))
      yield
    end
  end
  
end

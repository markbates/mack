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

module CommonHelpers
  def check_exception(klass, &block)
    valid = false
    begin
      yield
    rescue klass
      valid = true
    end
    return valid
  end
end

require 'rubygems'
require "test/unit"
# require 'test/spec'
require 'fileutils'

ENV["MACK_ENV"] = "test"
ENV["MACK_ROOT"] = File.join(File.dirname(__FILE__), "fake_application")

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

unless $drb_pid
  $drb_pid = Process.fork do
    puts exec('cachetastic_drb_server -vv')
  end
  sleep(2)
  Process.detach($drb_pid)
end

class Test::Unit::TestCase
  
end

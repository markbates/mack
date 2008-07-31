require 'rubygems'
require 'rack'
require 'digest'
require 'mack-facets'
require 'application_configuration'
require 'cachetastic'
require 'fileutils'
require 'log4r'
require 'crypt/rijndael'
require 'singleton'
require 'uri'
require 'drb'
require 'rinda/ring'
require 'rinda/tuplespace'
require 'builder'
require 'erubis'
require 'erb'
require 'genosaurus'
require 'net/http'
require 'pp'
require 'test/unit'

fl = File.join(File.dirname(__FILE__), "mack")

require File.join(fl, "initialization", "configuration.rb")

unless Mack::Configuration.initialized_core
  
  puts "Initializing logging..."
  require File.join(fl, "initialization", "logging.rb")
  

  Mack.logger.info "Initializing core classes..."
  # Require all the necessary files to make Mack actually work!
  lib_dirs = ["errors", "core_extensions", "utils", "runner_helpers", "routing", "view_helpers", "rendering", "controller", "tasks", "initialization/server", "generators", "distributed"]
  lib_dirs << "testing"# if Mack.env == "test"
  lib_dirs.each do |dir|
    dir_globs = Dir.glob(File.join(fl, dir, "**/*.rb"))
    dir_globs.each do |d|
      require d
    end
  end
  
  require File.join(fl, "runner")
  
  require File.join(fl, "initialization", "orm_support.rb")
  
  Mack::Configuration.initialized_core = true if Mack::Configuration.initialized_core.nil?

  Mack.logger.info "Initialization of Mack Core finished."
end
require 'rubygems'
require 'rack'
require 'digest'
require 'mack-facets'
require 'mack-encryption'
require 'configatron'
require 'fileutils'
require 'log4r'
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
require 'thread'
begin
  # just in case people don't have it installed.
  require 'ruby-debug'
rescue Exception => e
end

fl = File.join(File.dirname(__FILE__), "mack")
require File.join(fl, "initialization", "boot_loader.rb")
require File.join(fl, "initialization", "environment.rb")
require File.join(fl, "initialization", "configuration.rb")
require File.join(fl, "initialization", "logging.rb")

boot_load(:version) do
  require File.join(File.dirname(__FILE__), "mack", "version")
end

boot_load(:paths) do
  require File.join(File.dirname(__FILE__), "mack", "utils", "paths")
end

boot_load(:gems) do
  Mack.logger.debug "Initializing custom gems..." unless configatron.log.disable_initialization_logging
  load Mack::Paths.initializers("gems.rb")
  Mack::Utils::GemManager.instance.do_requires
end

boot_load(:core_classes) do
  Mack.logger.debug "Initializing core classes..." unless configatron.log.disable_initialization_logging
  # Require all the necessary files to make Mack actually work!
  lib_dirs = ["errors", "core_extensions", "utils", "sessions", "runner_helpers", "routing", "view_helpers", "rendering", "controller", "tasks", "initialization/server", "generators", "distributed"]
  lib_dirs << "testing"# if Mack.env == "test"
  lib_dirs.each do |dir|
    dir_globs = Dir.glob(File.join(File.dirname(__FILE__), "mack", dir, "**/*.rb"))
    dir_globs.each do |d|
      require d unless d.match(/console/)
    end
  end
end

boot_load(:runner) do
  require File.join(File.dirname(__FILE__), "mack", "runner")
end

boot_load(:load_mack_core, :version, :paths, :configuration, :logging, :core_classes, :gems) do
  Mack.logger.debug "Initialization of Mack Core finished." unless configatron.log.disable_initialization_logging
end

Mack::BootLoader.run(:load_mack_core)
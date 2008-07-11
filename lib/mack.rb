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
require 'ruby-debug'

require File.join(File.dirname(__FILE__), "initialization", "configuration.rb")

unless Mack::Configuration.initialized
  
  puts "Initializing logging..."
  require File.join(File.dirname(__FILE__), "initialization", "logging.rb")
  
  fl = File.join(File.dirname(__FILE__))

  Mack.logger.info "Starting application in #{Mack.env} mode."
  Mack.logger.info "Mack root: #{Mack.root}"

  Mack.logger.info "Initializing core classes..."
  # Require all the necessary files to make Mack actually work!
  lib_dirs = ["distributed", "errors", "core_extensions", "utils", "routing", "view_helpers", "rendering", "controller", "tasks", "initialization/server", "generators"]
  lib_dirs << "testing" if Mack.env == "test"
  lib_dirs.each do |dir|
    dir_globs = Dir.glob(File.join(fl, dir, "**/*.rb"))
    dir_globs.each do |d|
      require d
    end
  end
  
  require File.join(File.dirname(__FILE__), "runner")
  
  require File.join(File.dirname(__FILE__), "initialization", "orm_support.rb")

  # ------------------------------------------------------------------------

  # set up application stuff:

  require File.join(File.dirname(__FILE__), "initialization", "application.rb")
  

  # ------------------------------------------------------------------------ 
  
  # Include ApplicationHelper into all controllers:
  Mack.logger.info "Initializing helpers..."
  # adding application_helper module into all defined controllers
  Object.constants.collect {|c| c if c.match(/Controller$/)}.compact.each do |cont|
    ApplicationHelper.include_safely_into(cont, Mack::Rendering::ViewTemplate)
  end
  
  # Find other Helpers and include them into their respective controllers.
  Object.constants.collect {|c| c if c.match(/Controller$/)}.compact.each do |cont|
    if Object.const_defined?("#{cont}Helper")
      h = "#{cont}Helper".constantize
      h.include_safely_into(cont, Mack::Rendering::ViewTemplate)
    end
  end
  
  # Find view level Helpers and include them into the Mack::Rendering::ViewTemplate
  Mack::ViewHelpers.constants.each do |cont|
      h = "Mack::ViewHelpers::#{cont}".constantize
      h.include_safely_into(Mack::Rendering::ViewTemplate)
  end
  
  Mack::Configuration.initialized = true if Mack::Configuration.initialized.nil?

  Mack.logger.info "Initialization finished."
end
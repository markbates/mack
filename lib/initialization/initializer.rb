require 'rubygems'
require 'rack'
require 'digest'
require 'ruby_extensions'
require 'application_configuration'
require 'cachetastic'
require 'fileutils'
require 'log4r'
require 'crypt/rijndael'
require 'singleton'

# Set up Mack constants, if they haven't already been set up.
unless Object.const_defined?("MACK_ENV")
  (Object::MACK_ENV = (ENV["MACK_ENV"] ||= "development")).to_sym
end
(Object::MACK_ROOT = (ENV["MACK_ROOT"] ||= FileUtils.pwd)) unless Object.const_defined?("MACK_ROOT")

Object::MACK_PUBLIC = File.join(MACK_ROOT, "public") unless Object.const_defined?("MACK_PUBLIC")
Object::MACK_APP = File.join(MACK_ROOT, "app") unless Object.const_defined?("MACK_APP")
Object::MACK_LIB = File.join(MACK_ROOT, "lib") unless Object.const_defined?("MACK_LIB")
Object::MACK_CONFIG = File.join(MACK_ROOT, "config") unless Object.const_defined?("MACK_CONFIG")
Object::MACK_VIEWS = File.join(MACK_APP, "views") unless Object.const_defined?("MACK_VIEWS")
Object::MACK_LAYOUTS = File.join(MACK_VIEWS, "layouts") unless Object.const_defined?("MACK_LAYOUTS")
Object::MACK_PLUGINS = File.join(MACK_ROOT, "vendor", "plugins") unless Object.const_defined?("MACK_PLUGINS")

unless Object.const_defined?("MACK_INITIALIZED")
  puts "Starting application in #{MACK_ENV} mode."
  
  Object::MACK_INITIALIZED = true
  
  # Set up 'Rails' constants to allow for easier use of existing gems/plugins like application_configuration.
  # I would like to take these out eventually, but for right now, it's not doing too much harm.
  # Object::RAILS_ENV = MACK_ENV unless Object.const_defined?("RAILS_ENV")
  # Object::RAILS_ROOT = MACK_ROOT unless Object.const_defined?("RAILS_ROOT")

  require File.join(File.dirname(__FILE__), "configuration.rb")

  require File.join(File.dirname(__FILE__), "initializers", "logging.rb")
  
  require File.join(File.dirname(__FILE__), "initializers", "orm_support.rb")

  fl = File.join(File.dirname(__FILE__), "..")

  # Require all the necessary files to make Mack actually work!
  ["errors", "core_extensions", "utils", "test_extensions", "routing", "rendering", "sea_level", "tasks", "initialization/server", "generators"].each do |dir|
    dir_globs = Dir.glob(File.join(fl, dir, "**/*.rb"))
    dir_globs.each do |d|
      require d
    end
  end
  


  # ------------------------------------------------------------------------

  # set up application stuff:

  # set up routes:
  require File.join(MACK_ROOT, "config", "routes")

  # require 'plugins':
  require File.join(File.dirname(__FILE__), "initializers", "plugins.rb")
  
  # require 'app' files:
  Dir.glob(File.join(MACK_APP, "**/*.rb")).each do |d|
    require d
  end
  
  # require 'lib' files:
  Dir.glob(File.join(MACK_LIB, "**/*.rb")).each do |d|
    require d
  end
  

  # ------------------------------------------------------------------------ 
  
  # Include ApplicationHelper into all controllers:
  if Object.const_defined?("ApplicationHelper")
    ApplicationHelper.include_safely_into(Mack::Controller::Base, Mack::ViewBinder)
  end
  # Find other Helpers and include them into their respective controllers.
  Object.constants.collect {|c| c if c.match(/Controller$/)}.compact.each do |cont|
    if Object.const_defined?("#{cont}Helper")
      h = "#{cont}Helper".constantize
      h.include_safely_into(cont, Mack::ViewBinder)
    end
  end
  
  # Find view level Helpers and include them into the Mack::ViewBinder
  Mack::ViewHelpers.constants.each do |cont|
      h = "Mack::ViewHelpers::#{cont}".constantize
      h.include_safely_into(Mack::ViewBinder)
  end
end
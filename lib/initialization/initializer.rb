require 'rubygems'
require 'rack'
require 'digest'
require 'mack_ruby_core_extensions'
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

require File.join(File.dirname(__FILE__), "constants.rb")

unless Object.const_defined?("MACK_INITIALIZED")
  puts "Starting application in #{MACK_ENV} mode."
  puts "Mack root: #{MACK_ROOT}"
  
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
  ["distributed", "errors", "core_extensions", "utils", "test_extensions", "routing", "rendering", "sea_level", "tasks", "initialization/server", "generators"].each do |dir|
    dir_globs = Dir.glob(File.join(fl, dir, "**/*.rb"))
    dir_globs.each do |d|
      require d
    end
  end
  


  # ------------------------------------------------------------------------

  # set up application stuff:

  # set up routes:
  require File.join(MACK_CONFIG, "routes")
  
  # set up initializers:
  Dir.glob(File.join(MACK_CONFIG, "initializers", "**/*.rb")) do |d|
    require d
  end
  Mack::Utils::GemManager.instance.do_requires

  # require 'plugins':
  require File.join(File.dirname(__FILE__), "initializers", "plugins.rb")
  
  # make sure that default_controller is available to other controllers
  path = File.join(MACK_APP, "controllers", "default_controller.rb")
  require path if File.exists?(path) 
  
  # require 'app' files:
  Dir.glob(File.join(MACK_APP, "**/*.rb")).each do |d|
    # puts "d: #{d}"
    begin
      require d
    rescue NameError => e
      if e.message.match("uninitialized constant")
        mod = e.message.gsub("uninitialized constant ", "")
        x =%{
          module ::#{mod}
          end
        }
        eval(x)
        require d
      else
        raise e
      end
    end
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
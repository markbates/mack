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
require 'net/http'

require File.join(File.dirname(__FILE__), "initialization", "configuration.rb")

unless Mack::Configuration.initialized
  
  puts "Starting application in #{Mack::Configuration.env} mode."
  puts "Mack root: #{Mack::Configuration.root}"
  
  require File.join(File.dirname(__FILE__), "initialization", "logging.rb")
  
  require File.join(File.dirname(__FILE__), "initialization", "orm_support.rb")

  fl = File.join(File.dirname(__FILE__))

  # Require all the necessary files to make Mack actually work!
  ["distributed", "errors", "core_extensions", "utils", "test_extensions", "routing", "rendering", "controller", "tasks", "initialization/server", "generators"].each do |dir|
    dir_globs = Dir.glob(File.join(fl, dir, "**/*.rb"))
    dir_globs.each do |d|
      require d
    end
  end
  


  # ------------------------------------------------------------------------

  # set up application stuff:

  # set up routes:
  require File.join(Mack::Configuration.config_directory, "routes")
  
  # set up initializers:
  Dir.glob(File.join(Mack::Configuration.config_directory, "initializers", "**/*.rb")) do |d|
    require d
  end
  Mack::Utils::GemManager.instance.do_requires

  # require 'plugins':
  require File.join(File.dirname(__FILE__), "initialization", "plugins.rb")
  
  # make sure that default_controller is available to other controllers
  path = File.join(Mack::Configuration.app_directory, "controllers", "default_controller.rb")
  require path if File.exists?(path) 
  
  # require 'app' files:
  Dir.glob(File.join(Mack::Configuration.app_directory, "**/*.rb")).each do |d|
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
  Dir.glob(File.join(Mack::Configuration.lib_directory, "**/*.rb")).each do |d|
    require d
  end
  

  # ------------------------------------------------------------------------ 
  
  # Include ApplicationHelper into all controllers:
  if Object.const_defined?("ApplicationHelper")
    ApplicationHelper.include_safely_into(Mack::Controller::Base, Mack::Rendering::ViewTemplate)
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
  
  Mack::Configuration.set(:initialized, "true") if Mack::Configuration.initialized.nil?
end

require File.join(File.dirname(__FILE__), "runner")
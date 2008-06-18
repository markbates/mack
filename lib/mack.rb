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
require 'markaby'
require 'haml'
require 'genosaurus'
require 'net/http'
require 'pp'

require File.join(File.dirname(__FILE__), "initialization", "configuration.rb")

unless Mack::Configuration.initialized
  
  puts "Initializing logging..."
  require File.join(File.dirname(__FILE__), "initialization", "logging.rb")
  
  fl = File.join(File.dirname(__FILE__))

  Mack.logger.info "Starting application in #{Mack::Configuration.env} mode."
  Mack.logger.info "Mack root: #{Mack::Configuration.root}"

  Mack.logger.info "Initializing core classes..."
  # Require all the necessary files to make Mack actually work!
  ["distributed", "errors", "core_extensions", "utils", "test_extensions", "routing", "view_helpers", "rendering", "controller", "tasks", "initialization/server", "generators"].each do |dir|
    dir_globs = Dir.glob(File.join(fl, dir, "**/*.rb"))
    dir_globs.each do |d|
      require d
    end
  end
  
  require File.join(File.dirname(__FILE__), "runner")
  
  require File.join(File.dirname(__FILE__), "initialization", "orm_support.rb")

  # ------------------------------------------------------------------------

  # set up application stuff:

  # set up routes:
  Mack.logger.info "Initializing routes..."
  require File.join(Mack::Configuration.config_directory, "routes")
  
  # set up initializers:
  Mack.logger.info "Initializing custom initializers..."
  Dir.glob(File.join(Mack::Configuration.config_directory, "initializers", "**/*.rb")) do |d|
    require d
  end
  Mack.logger.info "Initializing custom gems..."
  Mack::Utils::GemManager.instance.do_requires

  # require 'plugins':
  Mack.logger.info "Initializing plugins..."
  require File.join(File.dirname(__FILE__), "initialization", "plugins.rb")
  
  # make sure that default_controller is available to other controllers
  path = File.join(Mack::Configuration.app_directory, "controllers", "default_controller.rb")
  require path if File.exists?(path) 
  
  # require 'app' files:
  Mack.logger.info "Initializing 'app' classes..."
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
  Mack.logger.info "Initializing lib classes..."
  Dir.glob(File.join(Mack::Configuration.lib_directory, "**/*.rb")).each do |d|
    require d
  end
  

  # ------------------------------------------------------------------------ 
  
  # Include ApplicationHelper into all controllers:
  Mack.logger.info "Initializing helpers..."
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

  Mack.logger.info "Initialization finished."
end
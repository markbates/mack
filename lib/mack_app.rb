# require 'rubygems'
# require 'rack'
# require 'digest'
# require 'mack-facets'
# require 'application_configuration'
# require 'cachetastic'
# require 'fileutils'
# require 'log4r'
# require 'crypt/rijndael'
# require 'singleton'
# require 'uri'
# require 'drb'
# require 'rinda/ring'
# require 'rinda/tuplespace'
# require 'builder'
# require 'erubis'
# require 'erb'
# require 'genosaurus'
# require 'net/http'
# require 'pp'
# require 'test/unit'
# require 'ruby-debug'

require File.join(File.dirname(__FILE__), "initialization", "configuration.rb")

unless Mack::Configuration.initialized_application
  
  Mack.logger.info "Starting application in #{Mack.env} mode."
  Mack.logger.info "Mack root: #{Mack.root}"

  require File.join(File.dirname(__FILE__), "initialization", "application.rb")
  
  require File.join(File.dirname(__FILE__), "initialization", "helpers.rb")
  
  Mack::Configuration.initialized_application = true if Mack::Configuration.initialized_application.nil?

  Mack.logger.info "Initialization of Mack Application Environment finished."
end
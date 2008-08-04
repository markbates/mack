require 'ruby-debug'

fl = File.join(File.dirname(__FILE__), "mack")

require File.join(fl, "initialization", "configuration.rb")

unless Mack::Configuration.initialized_application
  
  Mack.logger.debug "Starting application in #{Mack.env} mode."
  Mack.logger.debug "Mack root: #{Mack.root}"

  require File.join(fl, "initialization", "application.rb")
  
  require File.join(fl, "initialization", "helpers.rb")
  
  Mack::Configuration.initialized_application = true if Mack::Configuration.initialized_application.nil?

  Mack.logger.debug "Initialization of Mack Application Environment finished."
end
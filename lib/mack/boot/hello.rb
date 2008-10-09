run_once do
  
  require File.join_from_here('logging.rb')
  require File.join_from_here('version.rb')
  
  Mack.reset_logger!
  
  Mack.logger.debug "Mack root: #{Mack.root}"
  Mack.logger.debug "Mack version: #{Mack::VERSION}"
  Mack.logger.debug "Starting application in #{Mack.env} mode."
end
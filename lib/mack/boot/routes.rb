if __FILE__ == $0
  require 'fileutils'
  ENV["MACK_ROOT"] = File.join(FileUtils.pwd, '..', '..', '..', 'test', 'fake_application')
end

require 'mack-facets'

run_once do
  
  require File.join_from_here('lib')
  
  Mack.logger.debug "Initializing routing..." unless configatron.mack.log.disable_initialization_logging
  
  require Mack::Paths.config('routes.rb')
  
end
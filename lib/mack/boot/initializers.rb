if __FILE__ == $0
  require 'fileutils'
  ENV["MACK_ROOT"] = File.join(FileUtils.pwd, '..', '..', '..', 'test', 'fake_application')
end

require 'mack-facets'

run_once do
  
  require File.join_from_here('core')
  
  Mack.logger.debug "Initializing custom initializers..." unless configatron.mack.log.disable_initialization_logging
  
  Dir.glob(Mack::Paths.initializers('**/*.rb')).each do |d|
    d = File.expand_path(d)
    puts d
    require d
  end
  
end
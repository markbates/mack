if __FILE__ == $0
  require 'fileutils'
  ENV["MACK_ROOT"] = File.join(FileUtils.pwd, '..', '..', '..', 'test', 'fake_application')
end

require 'mack-facets'

run_once do
  
  require File.join_from_here('configuration.rb')
  require File.join_from_here('logging.rb')
  require File.join_from_here('extensions.rb')
  
  Mack.logger.debug "Initializing custom gems..." unless configatron.mack.log.disable_initialization_logging
  
  require File.join_from_here('..', 'utils', 'gem_manager.rb')
  
  require Mack::Paths.initializers("gems.rb") if File.exists?(Mack::Paths.initializers("gems.rb"))
  Mack::Utils::GemManager.instance.do_task_requires
  
end
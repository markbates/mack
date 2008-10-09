if __FILE__ == $0
  require 'fileutils'
  ENV["MACK_ROOT"] = File.join(FileUtils.pwd, '..', '..', '..', 'test', 'fake_application')
end

require 'mack-facets'

run_once do
  
  require File.join_from_here('gems.rb')
  
  Mack.logger.debug "Initializing plugins..." unless configatron.mack.log.disable_initialization_logging
  plugins = [] # a list of all plugins
  Dir.glob(Mack::Paths.plugins("*")).each do |d|
    plugins << d
    $: << File.join(d, "lib") # add the lib for this plugin to the global load path
  end
  plugins.sort.each do |plug|
    begin
      require File.join(plug, "init.rb") # load the init.rb for each plugin.
    rescue Exception => e
      puts e.message
    end
    $:.delete(File.join(plug, "lib")) # remove the plugins lib directory from the global load path.
  end
  
end
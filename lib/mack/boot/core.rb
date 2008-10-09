# :version
# :paths
# :configuration
# :logging
# :core_classes
# :gems
require 'mack-facets'
require 'rack'
require 'genosaurus'
run_once do
  
  require File.join_from_here('configuration.rb')
  require File.join_from_here('logging.rb')
  
  Mack.logger.debug "Initializing core classes..." unless configatron.mack.log.disable_initialization_logging
  # Require all the necessary files to make Mack actually work!
  lib_dirs = ["assets", "errors", "core_extensions", "utils", "sessions", "runner_helpers", "routing", "view_helpers", "rendering", "controller", "tasks", "initialization/server", "generators"]
  lib_dirs << "testing"# if Mack.env == "test"
  lib_dirs.each do |dir|
    dir_globs = Dir.glob(File.join_from_here("..", dir, "**/*.rb"))
    dir_globs.sort.each do |d|
      puts File.expand_path(d)
      require File.expand_path(d) unless d.match(/console/)
    end
  end
  
  require File.join_from_here('..', 'runner.rb')
end
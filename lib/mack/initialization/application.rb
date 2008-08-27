# set up initializers:
Mack.logger.debug "Initializing custom initializers..." unless app_config.log.disable_initialization_logging
Dir.glob(Mack::Paths.initializers("**/*.rb")) do |d|
  require d
end
Mack.logger.debug "Initializing custom gems..." unless app_config.log.disable_initialization_logging
Mack::Utils::GemManager.instance.do_requires

# require 'plugins':
Mack.logger.debug "Initializing plugins..." unless app_config.log.disable_initialization_logging
require File.join(File.dirname(__FILE__), "plugins.rb")

# make sure that default_controller is available to other controllers
path = Mack::Paths.controllers("default_controller.rb")
require path if File.exists?(path) 

# require 'lib' files:
Mack.logger.debug "Initializing lib classes..." unless app_config.log.disable_initialization_logging
Dir.glob(Mack::Paths.lib("**/*.rb")).each do |d|
  require d
end

# set up routes:
Mack.logger.debug "Initializing routes..." unless app_config.log.disable_initialization_logging
require Mack::Paths.config("routes")

# require 'app' files:
Mack.logger.debug "Initializing 'app' classes..." unless app_config.log.disable_initialization_logging
Dir.glob(Mack::Paths.app("**/*.rb")).each do |d|
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
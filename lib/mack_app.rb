begin
  # just in case people don't have it installed.
  require 'ruby-debug'
rescue Exception => e
end
# 
# 
# fl = File.join(File.dirname(__FILE__), "mack")
# 
# require File.join(fl, "initialization", "configuration.rb")
# 
# unless Mack::Configuration.initialized_application
#   
#   Mack.logger.debug "Starting application in #{Mack.env} mode."
#   Mack.logger.debug "Mack root: #{Mack.root}"
#   Mack.logger.debug "Mack version: #{Mack::VERSION}"
# 
#   Mack.reset_logger!
# 
#   # Mack::BootLoader.run
# 
#   # require File.join(fl, "initialization", "application.rb")
#   
#   require File.join(fl, "initialization", "helpers.rb")
#   
#   Mack::Configuration.initialized_application = true if Mack::Configuration.initialized_application.nil?
# 
#   Mack.logger.debug "Initialization of Mack Application Environment finished."
# end

boot_load(:start_mack_application, :configuration, :print_hello_banner, :app_files) do
  Mack.logger.debug "Initialization of Mack Application Environment finished."
end

# boot_load(:configuration, :logging) do
#   require File.join(File.join(File.dirname(__FILE__), "mack"), "initialization", "configuration.rb")
# end

boot_load(:print_hello_banner, :configuration) do
  Mack.logger.debug "Starting application in #{Mack.env} mode."
  Mack.logger.debug "Mack root: #{Mack.root}"
  Mack.logger.debug "Mack version: #{Mack::VERSION}"
end

boot_load(:initializers) do
  Mack.logger.debug "Initializing custom initializers..." unless app_config.log.disable_initialization_logging
  Dir.glob(Mack::Paths.initializers("**/*.rb")) do |d|
    require d
  end  
end

boot_load(:gems, :initializers) do
  Mack.logger.debug "Initializing custom gems..." unless app_config.log.disable_initialization_logging
  Mack::Utils::GemManager.instance.do_requires  
end

# boot_load(:plugins, :initializers) do
#   # require 'plugins':
#   Mack.logger.debug "Initializing plugins..." unless app_config.log.disable_initialization_logging
#   require File.join(File.dirname(__FILE__), "plugins.rb")  
# end

boot_load(:lib, :plugins, :gems) do
  # require 'lib' files:
  Mack.logger.debug "Initializing lib classes..." unless app_config.log.disable_initialization_logging
  Dir.glob(Mack::Paths.lib("**/*.rb")).each do |d|
    require d
  end
end

boot_load(:default_controller, :lib) do
  # make sure that default_controller is available to other controllers
  path = Mack::Paths.controllers("default_controller.rb")
  require path if File.exists?(path)
end

boot_load(:routes) do
  # set up routes:
  Mack.logger.debug "Initializing routes..." unless app_config.log.disable_initialization_logging
  require Mack::Paths.config("routes")
end

boot_load(:app_files, :default_controller) do
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
end


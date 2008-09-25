boot_load(:initializers) do
  Mack.logger.debug "Initializing custom initializers..." unless configatron.log.disable_initialization_logging
  Dir.glob(Mack::Paths.initializers("**/*.rb")) do |d|
    require d
  end  
end

boot_load(:lib, :plugins, :gems) do
  # require 'lib' files:
  Mack.logger.debug "Initializing lib classes..." unless configatron.log.disable_initialization_logging
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
  Mack.logger.debug "Initializing routes..." unless configatron.log.disable_initialization_logging
  require Mack::Paths.config("routes")
end

boot_load(:app_files, :default_controller) do
  # require 'app' files:
  Mack.logger.debug "Initializing 'app' classes..." unless configatron.log.disable_initialization_logging
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
  
  # Add default assets
  assets.defaults do |a| 
    a.add_css "scaffold"
  end
end
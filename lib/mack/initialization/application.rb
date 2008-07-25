# set up initializers:
Mack.logger.info "Initializing custom initializers..."
Dir.glob(File.join(Mack.root, "config", "initializers", "**/*.rb")) do |d|
  require d
end
Mack.logger.info "Initializing custom gems..."
Mack::Utils::GemManager.instance.do_requires

# require 'plugins':
Mack.logger.info "Initializing plugins..."
require File.join(File.dirname(__FILE__), "plugins.rb")

# make sure that default_controller is available to other controllers
path = File.join(Mack.root, "app", "controllers", "default_controller.rb")
require path if File.exists?(path) 

# require 'lib' files:
Mack.logger.info "Initializing lib classes..."
Dir.glob(File.join(Mack.root, "lib", "**/*.rb")).each do |d|
  require d
end

# set up routes:
Mack.logger.info "Initializing routes..."
require File.join(Mack.root, "config", "routes")

# require 'app' files:
Mack.logger.info "Initializing 'app' classes..."
Dir.glob(File.join(Mack.root, "app", "**/*.rb")).each do |d|
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
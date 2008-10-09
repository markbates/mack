if __FILE__ == $0
  require 'fileutils'
  ENV["MACK_ROOT"] = File.join(FileUtils.pwd, '..', '..', '..', 'test', 'fake_application')
end

require 'mack-facets'
run_once do
  
  require File.join_from_here('paths.rb')
  require File.join_from_here('configuration.rb')
  require File.join_from_here('logging.rb')
  require File.join_from_here('extensions.rb')
  require File.join_from_here('assets.rb')
  require File.join_from_here('core.rb')
  require File.join_from_here('gems.rb')
  require File.join_from_here('plugins.rb')
  require File.join_from_here('lib.rb')
  
  Mack.logger.debug "Initializing 'app' classes..." unless configatron.mack.log.disable_initialization_logging
  
  # make sure that default_controller is available to other controllers
  path = Mack::Paths.controllers("default_controller.rb")
  require path if File.exists?(path)
  
  Dir.glob(Mack::Paths.app("**/*.rb")).each do |d|
    begin
      d = File.expand_path(d)
      puts d
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
  assets_mgr.defaults do |a| 
    a.add_css "scaffold" if File.exists?Mack::Paths.stylesheets("scaffold.css")
  end
  
end
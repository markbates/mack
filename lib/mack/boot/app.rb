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
  
  init_message('application')
  
  # make sure that default_controller is available to other controllers
  path = Mack::Paths.controllers("default_controller.rb")
  require path if File.exists?(path)
  
  search_path(:app).each do |path|
    Dir.glob(File.join(path, "**/*.rb")).each do |d|
      begin
        d = File.expand_path(d)
        # puts d
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
  
  # Add default assets
  assets_mgr.defaults do |a| 
    a.add_css "scaffold" if File.exists?Mack::Paths.stylesheets("scaffold.css")
  end
  
end
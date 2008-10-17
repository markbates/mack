require 'mack-facets'

run_once do
  
  require File.join_from_here('lib')
  
  init_message('routes')
  
  # We want local routes to be first
  Mack.search_path_local_first(:config).each do |path|
    f = File.join(path, 'routes.rb')
    require f if File.exists?(f)
  end
  
end
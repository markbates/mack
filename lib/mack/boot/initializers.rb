require 'mack-facets'

run_once do
  
  require File.join_from_here('core')
  
  init_message('initializers')
  
  Mack.search_path(:initializers).each do |path|
    Dir.glob(File.join(path, '**/*.rb')).each do |d|
      d = File.expand_path(d)
      # puts d
      require d
    end
  end
  
end
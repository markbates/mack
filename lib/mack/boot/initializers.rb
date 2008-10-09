if __FILE__ == $0
  require 'fileutils'
  ENV["MACK_ROOT"] = File.join(FileUtils.pwd, '..', '..', '..', 'test', 'fake_application')
end

require 'mack-facets'

run_once do
  
  require File.join_from_here('core')
  
  init_message('initializers')
  
  search_path(:initializers).each do |path|
    Dir.glob(File.join(path, '**/*.rb')).each do |d|
      d = File.expand_path(d)
      # puts d
      require d
    end
  end
  
end
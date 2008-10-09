require 'mack-facets'

run_once do
  
  require File.join_from_here('paths.rb')
  
  puts "Initializing extensions"
  
  Dir.glob(File.join_from_here('..', 'core_extensions', '**/*.rb')).each do |d|
    d = File.expand_path(d)
    puts d
    require d
  end
  
end
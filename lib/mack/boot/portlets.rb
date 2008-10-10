run_once do
  
  require File.join_from_here('paths.rb')
  
  Dir.glob(File.join_from_here('..', 'portlets', '**/*.rb')).each do |d|
    require File.expand_path(d)
  end
  
  Mack.search_path(:initializers).each do |path|
    f = File.join(path, 'portlets.rb')
    require f if File.exists?(f)
  end
  
  required_portlets_list.each do |p|
    puts "portlet: #{p}"
    gem p.to_s
    require p.to_s
  end
  
end
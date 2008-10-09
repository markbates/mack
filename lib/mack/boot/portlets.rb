run_once do
  
  require File.join_from_here('paths.rb')
  
  require File.join_from_here('..', 'utils', 'portlets_manager.rb')
  
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
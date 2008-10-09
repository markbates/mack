run_once do
  
  # init_message('assets')
  
  Dir.glob(File.join_from_here('..', 'assets', '**/*.rb')).each do |f|
    f = File.expand_path(f)
    require f
  end
  
end
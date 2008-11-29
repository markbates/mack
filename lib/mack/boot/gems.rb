run_once do
  
  require File.join_from_here('configuration.rb')
  require File.join_from_here('logging.rb')
  require File.join_from_here('extensions.rb')
  
  init_message('custom gems')
  
  require File.join_from_here('..', 'utils', 'gem_manager.rb')
  
  require 'benchmark'
  
  Mack.search_path(:initializers).each do |path|
    f = File.join(path, 'gems.rb')
    require f if File.exists?(f)
  end
  
  # puts "total gem load time"
  # puts Benchmark.realtime{
    Mack::Utils::GemManager.instance.do_requires
  # }
  
end
if __FILE__ == $0
  require 'fileutils'
  ENV["MACK_ROOT"] = File.join(FileUtils.pwd, '..', '..', '..', 'test', 'fake_application')
end

require 'mack-facets'

run_once do
  
  require File.join_from_here('configuration.rb')
  require File.join_from_here('logging.rb')
  require File.join_from_here('extensions.rb')
  
  init_message('custom gem Rake tasks')
  
  require File.join_from_here('..', 'utils', 'gem_manager.rb')
  
  Mack.search_path(:initializers).each do |path|
    f = File.join(path, 'gems.rb')
    require f if File.exists?(f)
  end
  
  Mack::Utils::GemManager.instance.do_task_requires
  
end
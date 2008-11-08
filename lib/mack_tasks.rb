puts "***** #{File.basename(__FILE__)} ****"
Dir.glob(File.join(File.dirname(__FILE__), 'gems', '*')).each do |gem|
  puts "File.expand_path(File.join(gem, 'lib')): #{File.expand_path(File.join(gem, 'lib'))}"
  $:.insert(0, File.expand_path(File.join(gem, 'lib')))
end

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'fileutils'
require 'rubygems'
require 'mack-facets'
require 'configatron'

fl = File.join_from_here('mack')

f_tasks = File.join(FileUtils.pwd, 'vendor', 'framework', 'mack', 'lib', 'mack_tasks.rb')
if File.exists?(f_tasks) && f_tasks != __FILE__
  # puts "Run from the local copy"
  require f_tasks
else
  require File.join_from_here('..', 'bin', 'gem_load_path.rb')
  require File.join(fl, 'tasks', 'rake_helpers.rb')
  
  require File.join(fl, 'boot', 'version.rb')
  require File.join(fl, 'boot', 'extensions.rb')
  require File.join(fl, 'boot', 'paths.rb')
  require File.join(fl, 'boot', 'portlets.rb')
  require File.join(fl, 'boot', 'configuration.rb')
  require File.join(fl, 'boot', 'environment.rb')
  require File.join(fl, 'boot', 'gem_tasks.rb')
  
  # Requires all rake tasks that ship with the Mack framework.
  [fl, Mack.search_path(:lib), Mack.search_path(:plugins)].flatten.each do |dir|
    begin
      require File.join(dir, "tasks", "rake_helpers.rb")
    rescue Exception => e
      # raise e
    end
    files = Dir.glob(File.join(dir, "**/*.rake"))
    files.each do |f|
      unless f == __FILE__
        load f
      end
    end
  end  
  
  
  # # puts "running mack_tasks from: #{fl}"
  # require File.join(File.dirname(__FILE__), '..', 'bin', 'gem_load_path')
  # 
  # require File.join(fl, 'tasks', 'rake_helpers')
  # require File.join(fl, 'core_extensions', 'kernel')
  # require File.join(fl, 'utils', 'paths')
  # 
  # require File.join(fl, 'initialization', 'boot_loader')
  # require File.join(fl, 'initialization', 'configuration')
  # 
  # Mack::BootLoader.run(:configuration)
  # require File.join(fl, 'utils', 'gem_manager')
  # 
  # require Mack::Paths.initializers("gems.rb")
  # Mack::Utils::GemManager.instance.do_task_requires
  # 
  # # Requires all rake tasks that ship with the Mack framework.
  # [fl, Mack::Paths.lib, Mack::Paths.plugins].each do |dir|
  #   begin
  #     require File.join(dir, "tasks", "rake_helpers.rb")
  #   rescue Exception => e
  #     # raise e
  #   end
  #   files = Dir.glob(File.join(dir, "**/*.rake"))
  #   files.each do |f|
  #     unless f == __FILE__
  #       load f
  #     end
  #   end
  # end
  
end
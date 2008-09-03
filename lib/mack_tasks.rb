require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'fileutils'
require 'rubygems'
require 'mack-facets'
require 'application_configuration'

fl = File.join(File.dirname(__FILE__), 'mack')

f_tasks = File.join(FileUtils.pwd, 'vendor', 'framework', 'mack', 'lib', 'mack_tasks.rb')
if File.exists?(f_tasks) && f_tasks != __FILE__
  # puts "Run from the local copy"
  require f_tasks
else
  # puts "running mack_tasks from: #{fl}"

  require File.join(fl, 'tasks', 'rake_helpers')
  require File.join(fl, 'core_extensions', 'kernel')
  require File.join(fl, 'utils', 'paths')

  require File.join(fl, 'initialization', 'boot_loader')
  require File.join(fl, 'initialization', 'configuration')

  Mack::BootLoader.run(:configuration)
  require File.join(fl, 'utils', 'gem_manager')

  require Mack::Paths.initializers("gems.rb")
  Mack::Utils::GemManager.instance.do_task_requires

  # Requires all rake tasks that ship with the Mack framework.
  [fl, Mack::Paths.lib, Mack::Paths.plugins].each do |dir|
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
  
end
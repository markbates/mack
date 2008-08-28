require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rubygems'
require 'mack-facets'
require 'application_configuration'
# 
fl = File.join(File.dirname(__FILE__), 'mack')
# 
# require File.join(fl, "initialization", "boot_loader.rb")
# 
# # if ARGV.any?
  require File.join(File.dirname(__FILE__), 'mack_core')
# # else
# #   require File.join(fl, "utils", "paths.rb")
# #   require File.join(fl, "initialization", "configuration.rb")
# #   require File.join(fl, "initialization", "logging.rb")
# #   require File.join(fl, 'core_extensions', 'kernel')
# #   require File.join(fl, 'utils', 'gem_manager')
# # end
# 
# gems_rb = Mack::Paths.initializers("gems.rb")
# if File.exists?(gems_rb)
#   begin
#     require gems_rb
#     Mack::Utils::GemManager.instance.do_requires
#   rescue Gem::LoadError
#   end
# end
#   
# 
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
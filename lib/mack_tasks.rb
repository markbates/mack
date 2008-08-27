require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rubygems'
require 'mack-facets'
require 'application_configuration'

require File.join(File.dirname(__FILE__), "mack", "utils", "paths.rb")

require File.join(File.dirname(__FILE__), "mack", "initialization", "configuration.rb")

require File.join(File.dirname(__FILE__), 'mack_core')
gems_rb = Mack::Paths.initializers("gems.rb")
if File.exists?(gems_rb)
  begin
    require gems_rb
    Mack::Utils::GemManager.instance.do_requires
  rescue Gem::LoadError
  end
end

# Requires all rake tasks that ship with the Mack framework.
[File.join(File.dirname(__FILE__)), Mack::Paths.lib, Mack::Paths.plugins].each do |dir|
  begin
    require File.join(dir, "tasks", "rake_helpers.rb")
  rescue Exception => e
  end
  files = Dir.glob(File.join(dir, "**/*.rake"))
  files.each do |f|
    unless f == __FILE__
      load f
    end
  end
end
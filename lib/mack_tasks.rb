require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rubygems'
require 'mack-facets'
require 'application_configuration'

fl = File.join(File.dirname(__FILE__), 'mack')

require File.join(File.dirname(__FILE__), 'mack_core')

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
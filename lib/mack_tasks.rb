require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rubygems'
require 'application_configuration'

require File.join(File.dirname(__FILE__), "initialization", "configuration.rb")
orm = app_config.orm || 'data_mapper'
unless orm.nil?
  require "mack-#{orm}_tasks"
end

# Requires all rake tasks that ship with the Mack framework.
[File.join(File.dirname(__FILE__)), File.join(FileUtils.pwd, "lib"), File.join(FileUtils.pwd, "vendor", "plugins")].each do |dir|
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
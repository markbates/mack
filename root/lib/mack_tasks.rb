require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
# Requires all rake tasks that ship with the Mack framework.
[File.join(File.dirname(__FILE__)), File.join(FileUtils.pwd, "lib")].each do |dir|
  begin
    require File.join(dir, "tasks", "rake_helpers.rb")
  rescue Exception => e
  end
  files = Dir.glob(File.join(dir, "tasks", "*.rake"))
  files.each do |f|
    unless f == __FILE__
      load f
    end
  end
end
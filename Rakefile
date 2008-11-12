require File.join(File.dirname(__FILE__), 'lib', 'gems')

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
 
require File.join("lib", "mack", "tasks", "rake_helpers.rb")
Dir.glob(File.join("tasks", "**/*.rake")).each {|r| load r}
Dir.glob(File.join("lib", "mack", "tasks", "**/*.rake")).each {|r| load r}
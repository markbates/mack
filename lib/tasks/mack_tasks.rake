namespace :mack do
  
  desc "Loads the Mack environment. Default is development."
  task :environment do
    MACK_ENV = ENV["MACK_ENV"] ||= "development" unless Object.const_defined?("MACK_ENV")
    MACK_ROOT = FileUtils.pwd unless Object.const_defined?("MACK_ROOT")
    require 'mack'
    # require File.join(MACK_ROOT, "config", "boot.rb")
  end # environment

  desc "Loads an irb console allow you full access to the application w/o a browser."
  task :console do
    libs = []
    libs << "-r irb/completion"
    libs << "-r #{File.join(File.dirname(__FILE__), '..', 'mack')}"
    libs << "-r #{File.join(File.dirname(__FILE__), '..', 'initialization', 'console')}"
    exec "irb #{libs.join(" ")} --simple-prompt"
  end # console
  
end # mack

alias_task :console, "mack:console"
alias_task :environment, "mack:environment"

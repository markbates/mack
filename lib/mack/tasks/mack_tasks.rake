namespace :mack do
  
  desc "Loads the Mack environment. Default is development."
  task :environment do
    require File.join(File.dirname(__FILE__), '..', "..", 'mack_app')
  end # environment

  desc "Loads an irb console allow you full access to the application w/o a browser."
  task :console do
    libs = []
    libs << "-r irb/completion"
    libs << "-r #{File.join(File.dirname(__FILE__), '..', 'initialization', 'console')}"
    system "irb #{libs.join(" ")} --simple-prompt"
  end # console
  
end # mack

alias_task :console, "mack:console"
alias_task :environment, "mack:environment"

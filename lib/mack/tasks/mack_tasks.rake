namespace :mack do
  
  desc "Loads the Mack environment. Default is development."
  task :environment do
    Mack::Environment.load
  end # environment

  # desc "Loads an irb console allow you full access to the application w/o a browser."
  task :console do
    puts %{
This task has been removed. Please use the 'mackery' command to access the console:

  $ mackery console

The environment can be set like this:

  $ mackery console -e test
    }
  end # console
  
end # mack

alias_task :console, "mack:console"
alias_task :environment, "mack:environment"

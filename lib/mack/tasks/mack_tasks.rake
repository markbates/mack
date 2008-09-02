require 'fileutils'
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
  
  namespace :freeze do
    
    desc "Freezes the Edge Mack code into your vendor/framework folder"
    task :edge do
      f_dir = File.join(FileUtils.pwd, 'vendor', 'framework')
      FileUtils.mkdir_p(f_dir)
      %w{mack mack-more}.each do |proj|
        proj_dir = File.join(f_dir, proj)
        if File.exists?(proj_dir)
          FileUtils.cd proj_dir
          system 'git pull'
        else
          FileUtils.cd f_dir
          system "git clone git://github.com/#{ENV["USERNAME"] || 'markbates'}/#{proj}.git"
        end
      end
    end
    
  end
  
end # mack

alias_task :console, "mack:console"
alias_task :environment, "mack:environment"

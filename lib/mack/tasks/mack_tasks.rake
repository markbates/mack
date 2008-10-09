require 'fileutils'
namespace :mack do
  
  desc "Loads the Mack environment. Default is development."
  task :environment do
    require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'mack'))
    Mack::Environment.load
  end # environment
  
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

alias_task :environment, "mack:environment"

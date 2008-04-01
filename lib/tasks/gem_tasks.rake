namespace :gem do
  
  desc "lists all the gem required for this application."
  task :list => :setup do
    Mack::Utils::GemManager.instance.required_gem_list.each do |g|
      puts g
    end
  end # list
  
  desc "installs the gems needed for this application."
  task :install => :setup do
    runner = Gem::GemRunner.new
    Mack::Utils::GemManager.instance.required_gem_list.each do |g|
      unless g.version.blank?
        runner.run(["install", g.name, "--version=#{g.version}"])
      else
        runner.run(["install", g.name])
      end
    end
  end # install
  
  private
  task :setup do
    gem 'mack'
    require 'core_extensions/kernel'
    require 'utils/gem_manager'
    gem 'mack_ruby_core_extensions'
    require 'mack_ruby_core_extensions'
    require File.join(FileUtils.pwd, "config", "gems")
    require 'rubygems'
    require 'rubygems/gem_runner'
    Gem.manage_gems
  end
  
end # gem
namespace :gem do
  
  desc "lists all the gem required for this application."
  task :list => :setup do
    Mack::Utils::GemManager.instance.required_gem_list.each do |g|
      puts "#{g[:name]}" << (g[:version].blank? ? '' : "-#{g[:version]}")
    end
  end # list
  
  desc "installs the gems needed for this application."
  task :install => :setup do
    Mack::Utils::GemManager.instance.required_gem_list.each do |g|
      puts `gem install #{g[:name]} #{g[:version].blank? ? '' : "--version=\"#{g[:version]}\""}`
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
  end
  
end # gem
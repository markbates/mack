namespace :gems do
  
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
      params = ["install", g.name.to_s]
      params << "--version=#{g.version}" if g.version?
      params << "--source=#{g.source}" if g.source?
      runner.run(params)
    end
  end # install
  
  private
  task :setup do
    # require File.join(File.dirname(__FILE__), "..", "core_extensions", "kernel")
    # require File.join(File.dirname(__FILE__), "..", "utils", "gem_manager")
    # require 'mack-facets'
    # require File.join(FileUtils.pwd, "config", "initializers", "gems")
    # require 'rubygems'
    require 'rubygems/gem_runner'
    Gem.manage_gems
  end
  
end # gem
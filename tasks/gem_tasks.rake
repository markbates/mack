require 'rake'
require 'rake/gempackagetask'
require 'rake/clean'
require 'rake/testtask'
require 'find'
require 'fileutils'

require 'rubyforge'
require 'rubygems'
require 'rubygems/gem_runner'
require 'singleton'

require 'tasks/gem_helper'

namespace :gem do
  
  namespace :package  do
  
    desc "Package up the mack gem."
    task :mack do |t|
      pwd = FileUtils.pwd
      gh = GemHelper.instance
      FileUtils.rm_rf("#{pwd}/pkg", :verbose => true)
      gem_spec = Gem::Specification.new do |s|
        s.name = gh.gem_name
        s.version = gh.version
        s.summary = "Mack is a powerful, yet simple, web application framework."
        s.description = %{
          Mack is a powerful, yet simple, web application framework. 
          It takes some cues from the likes of Rails and Merb, so it's not entirely unfamiliar.
          Mack hopes to provide developers a great framework for building, and deploying, portal and
          distributed applications.
        }
        s.author = "markbates"
        s.email = "mark@mackframework.com"
        s.homepage = "http://www.mackframework.com"
        s.has_rdoc = true
        s.extra_rdoc_files = ["README", "CHANGELOG"]
        s.files = FileList["README", "lib/**/*.*", 'bin/**/*.*']
        s.require_paths << '.'
        s.require_paths << 'bin'
        s.require_paths << 'lib'
        
        s.bindir = "bin"
        s.executables << "mack"
        
        s.rdoc_options << '--title' << 'Mack' << '--main' << 'README' << '--line-numbers' << "--inline-source"
        
        s.add_dependency("rack", "0.3.0")
        s.add_dependency("mack_ruby_core_extensions", "0.1.5")
        s.add_dependency("application_configuration", "1.2.2")
        s.add_dependency("cachetastic", "1.4.2")
        s.add_dependency("log4r", "1.0.5")
        s.add_dependency("thin", "0.7.1")
        s.add_dependency("builder", "2.1.2")
        s.add_dependency("crypt", "1.1.4")
        
      
        s.rubyforge_project = gh.project
      end
      Rake::GemPackageTask.new(gem_spec) do |pkg|
        pkg.package_dir = "#{pwd}/pkg"
        pkg.need_zip = false
        pkg.need_tar = false
      end
      Rake::Task["package"].invoke
    end
  
  end
  
  namespace :install do
    
    desc "Package up and install the mack gem."
    task :mack => "gem:package:mack" do |t|
      GemHelper.instance.install
    end
    
  end
  
  namespace :release do
    
    desc "Package up, install, and release the mack gem."
    task :mack => ["gem:install:mack"] do |t|
      GemHelper.instance.release
    end
    
  end
  
end

alias_task :pack, "gem:package:mack"
alias_task :install, "gem:install:mack"
alias_task :release, "gem:release:mack"

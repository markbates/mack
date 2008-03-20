namespace :mack do
  
  desc "Loads the Mack environment. Default is development."
  task :environment do
    MACK_ENV = ENV["MACK_ENV"] ||= "development" unless Object.const_defined?("MACK_ENV")
    MACK_ROOT = FileUtils.pwd unless Object.const_defined?("MACK_ROOT")
    require File.join(MACK_ROOT, "config", "boot.rb")
  end # environment

  desc "Loads an irb console allow you full access to the application w/o a browser."
  task :console do
    libs = []
    libs << "-r irb/completion"
    libs << "-r #{File.join(File.dirname(__FILE__), '..', 'mack')}"
    libs << "-r #{File.join(File.dirname(__FILE__), '..', 'initialization', 'console')}"
    exec "irb #{libs.join(" ")} --simple-prompt"
  end # console
  
  namespace :server do

    desc "Starts the webserver."
    task :start do |t|

      require 'rubygems'
      require 'optparse'
      require 'optparse/time'
      require 'ostruct'
      require 'fileutils'

      d_handler = "WEBrick"
      begin
        require 'mongrel'
        d_handler = "mongrel"
      rescue Exception => e
      end
      begin
        require 'thin'
        d_handler = "thin"
      rescue Exception => e
      end

      MACK_ROOT = FileUtils.pwd unless Object.const_defined?("MACK_ROOT")

      options = OpenStruct.new
      options.port = (ENV["PORT"] ||= "3000") # Does NOT work with Thin!! You must edit the thin.yml file!
      options.handler = (ENV["HANDLER"] ||= d_handler)


      require File.join(MACK_ROOT, "config", "boot.rb")

      if options.handler == "thin"
        # thin_opts = ["start", "-r", "config/thin.ru"]
        thin_opts = ["start", "-C", "config/thin.yml"]
        Thin::Runner.new(thin_opts.flatten).run!
      else
        Mack::SimpleServer.run(options)
      end
    end # start

  end # server

  namespace :dump do
  
    desc "Dumps out the configuration for the specified environment."
    task :config => :environment do
      fcs = app_config.instance.instance_variable_get("@final_configuration_settings")
      conf = {}
      fcs.each_pair do |k, v|
        unless v.is_a?(Application::Configuration::Namespace)
          conf[k.to_s] = v unless k.to_s.match("__")
        end
      end
      pp conf
    end # config
  
  end # dump
  
end # mack

alias_task :console, "mack:console"
alias_task :server, "log:clear", "mack:server:start"
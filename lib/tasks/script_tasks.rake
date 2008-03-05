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
  end
  
end

alias_task :server, "log:clear", "server:start"
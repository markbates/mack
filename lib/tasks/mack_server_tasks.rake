namespace :mack do
  
  namespace :server do

    desc "Starts the webserver."
    task :start do |t|

      require 'rubygems'
      require 'optparse'
      require 'optparse/time'
      require 'ostruct'
      require 'fileutils'

      require 'thin'

      options = OpenStruct.new
      options.port = (ENV["PORT"] ||= "3000") # Does NOT work with Thin!! You must edit the thin.yml file!
      options.handler = (ENV["HANDLER"] ||= "thin")


      # require File.join(Mack.root, "config", "boot.rb")
      require 'mack'

      if options.handler == "thin"
        # thin_opts = ["start", "-r", "config/thin.ru"]
        thin_opts = ["start", "-C", "config/thin.yml"]
        Thin::Runner.new(thin_opts.flatten).run!
      else
        Mack::SimpleServer.run(options)
      end
    end # start

  end # server
  
end # mack

alias_task :server, "log:clear", "mack:server:start"
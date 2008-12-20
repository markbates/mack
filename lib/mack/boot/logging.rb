require 'rubygems'
require 'mack-facets'

run_once do
  
  require File.join_from_here('configuration.rb')
  
  # init_message('logging')
  
  # gem 'logging'
  require 'logging'
  
  require File.join_from_here('..', "utils", "ansi", "ansi_color.rb")
  require File.join_from_here('logging', 'filter')
  require File.join_from_here('logging', 'basic_layout.rb')
  require File.join_from_here('logging', 'color_layout.rb')
  
  module Logging # :nodoc:
    
    def self.level_name_from_num(num)
      h = ivar_cache do
        Logging::LEVELS.invert
      end
      h[num]
    end
    
    class LogEvent # :nodoc:
      
      def level_name
        ::Logging.level_name_from_num(self.level)
      end
      
    end
    
  end # Logging
  
  module Mack
  
    def self.logger
      $mack_default_logger
    end
  
    def self.logger=(log)
      $mack_default_logger = log
    end
  
    def self.reset_logger!
      log_directory = configatron.mack.log.retrieve(:root, Mack::Paths.log)
      begin
        FileUtils.mkdir_p(log_directory)
      rescue Exception => e
      end
      
      Mack.logger = ::Logging::RootLogger.new
      Mack.logger.add_appenders(::Logging::Appenders::File.new(Mack.env, :filename => File.join(log_directory, "#{Mack.env}.log"), :layout => Mack::Logging::BasicLayout.new))
      Mack.logger.add_appenders(::Logging::Appenders::Stdout.new(:layout => Mack::Logging::ColorLayout.new)) if Mack.env?(:development)
      Mack.logger.level = configatron.mack.log.retrieve(:level, :info)
    end
  
  end # Mack

  Mack.reset_logger!

end # run_once
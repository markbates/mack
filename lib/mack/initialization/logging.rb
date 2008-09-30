boot_load(:logging, :configuration) do
  
  require 'logging'
  require File.join(File.dirname(__FILE__), "..", "utils", "ansi", "ansi_color")
  require File.join(File.dirname(__FILE__), 'logging', 'filter')
  require File.join(File.dirname(__FILE__), 'logging', 'basic_layout')
  require File.join(File.dirname(__FILE__), 'logging', 'color_layout')
  
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
      log_directory = configatron.log.retrieve(:root, Mack::Paths.log)
      begin
        FileUtils.mkdir_p(log_directory)
      rescue Exception => e
      end
      
      Mack.logger = ::Logging::RootLogger.new
      Mack.logger.add_appenders(::Logging::Appenders::File.new(Mack.env, :filename => File.join(log_directory, "#{Mack.env}.log"), :layout => Mack::Logging::BasicLayout.new))
      Mack.logger.add_appenders(::Logging::Appenders::Stdout.new(:layout => Mack::Logging::ColorLayout.new)) if Mack.env?(:development)
      Mack.logger.level = configatron.log.retrieve(:level, :info)

    end
  
  end

  unless Mack.logger
    Mack.reset_logger!
  end # Mack

end # boot_load
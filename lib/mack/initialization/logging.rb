boot_load(:logging, :configuration) do
  require 'log4r'
  require File.join(File.dirname(__FILE__), "..", "utils", "ansi", "ansi_color")
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

      Mack.logger = Log4r::Logger.new('')
      Mack.logger.level =  Module.instance_eval("Log4r::#{(configatron.log.retrieve(:level, :info)).to_s.upcase}")

      format = Log4r::PatternFormatter.new(:pattern => "%l:\t[%d]\t%M")

      if Mack.env == "development"
        # console:
        Mack.logger.add(Log4r::StdoutOutputter.new('console', :formatter => format))
      end

      # file:
      Mack.logger.add(Log4r::FileOutputter.new('fileOutputter', :filename => File.join(log_directory, "#{Mack.env}.log"), :trunc => false, :formatter => format))    
    end
  
  end

  unless Mack.logger
    module Log4r # :nodoc:
      class IOOutputter # :nodoc:

        # let's not do this more than once. :)
        unless Log4r::IOOutputter.private_instance_methods.include?("old_write")

          alias_method :old_write, :write

          def write(data)
            case data
            when /^(DEBUG:|INFO:|WARN:|ERROR:|FATAL:)\s\[.*\]\s(SELECT|INSERT|UPDATE|DELETE|CREATE|DROP)/
              old_write(Mack::Utils::Ansi::Color.wrap(configatron.log.colors.db, data))
            else
              level = data.match(/^\w+/).to_s
              color = configatron.log.colors.retrieve("#{level.downcase}", nil)
              if color
                old_write(Mack::Utils::Ansi::Color.wrap(color, data))
              else
                old_write(data)
              end
            end
          end

        end

      end # IOOutputter
    end # Log4r
  
    Mack.reset_logger!
  end

  module Mack
    module Logging # :nodoc:
      # Used to house a list of filters for parameter logging. The initial list
      # includes password and password_confirmation
      class Filter
        include Singleton
      
        # The list of parameters you want filtered for logging.
        attr_reader :list
      
        def initialize
          @list = [:password, :password_confirmation]
        end
      
        # Adds 'n' number of parameter names to the list
        def add(*args)
          @list << args
          @list.flatten!
        end
      
        # Removes 'n' number of parameter names from the list
        def remove(*args)
          @list.delete_values(*args)
        end
      
        class << self
        
          def remove(*args)
            Mack::Logging::Filter.instance.remove(*args)
          end
        
          def add(*args)
            Mack::Logging::Filter.instance.add(*args)
          end
        
          def list
            Mack::Logging::Filter.instance.list
          end
        
        end
      
      end
    end
  end
end
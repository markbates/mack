#--
# Configure logging
#++

module Mack
  
  def self.logger
    $mack_default_logger
  end
  
  def self.logger=(log)
    $mack_default_logger = log
  end
  
end

unless Mack.logger
  log_directory = app_config.log_root || File.join(Mack::Configuration.root, "log")
  FileUtils.mkdir_p(log_directory)

  Mack.logger = Log4r::Logger.new('')
  Mack.logger.level =  Module.instance_eval("Log4r::#{(app_config.log_level || :info).to_s.upcase}")
  
  format = Log4r::PatternFormatter.new(:pattern => "%l:\t[%d]\t%M")
  
  if Mack::Configuration.env == "development"
    # console:
    Mack.logger.add(Log4r::StdoutOutputter.new('console', :formatter => format))
  end
  
  # file:
  Mack.logger.add(Log4r::FileOutputter.new('fileOutputter', :filename => File.join(log_directory, "#{Mack::Configuration.env}.log"), :trunc => false, :formatter => format))
end
#--
# Configure logging
#++
include Log4r

log_dir_loc = File.join(MACK_ROOT, "log")
FileUtils.mkdir_p(log_dir_loc)

unless Object.const_defined?("MACK_DEFAULT_LOGGER")
  log = Log4r::Logger.new('')
  log.level =  Module.instance_eval("Log4r::#{app_config.log.level.to_s.upcase}")
  # console:
  if app_config.log.console
    console_format = PatternFormatter.new(:pattern => app_config.log.console_format)
    log.add(Log4r::StdoutOutputter.new('console', :formatter => console_format))
  end
  # file:
  if app_config.log.file
    file_format = PatternFormatter.new(:pattern => app_config.log.file_format)
    log.add(FileOutputter.new('fileOutputter', :filename => File.join(log_dir_loc, "#{MACK_ENV}.log"), :trunc => false, :formatter => file_format))
  end
  
  Object::MACK_DEFAULT_LOGGER = log
end
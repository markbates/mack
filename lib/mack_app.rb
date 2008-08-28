fl = File.join(File.dirname(__FILE__), "mack")
require File.join(fl, "initialization", "application.rb")
require File.join(fl, "initialization", "helpers.rb")
require File.join(fl, "initialization", "plugins.rb")

boot_load(:start_mack_application, :configuration, :print_hello_banner, :routes, :helpers, :app_files, :runner) do
  Mack.logger.debug "Initialization of Mack Application Environment finished."
end

boot_load(:print_hello_banner, :configuration) do
  Mack.reset_logger!
  Mack.logger.debug "Mack root: #{Mack.root}"
  Mack.logger.debug "Mack version: #{Mack::VERSION}"
  Mack.logger.debug "Starting application in #{Mack.env} mode."
end

Mack::BootLoader.run(:start_mack_application)
desc "Loads the Mack environment. Default is development."
task :environment do
  MACK_ENV = ENV["MACK_ENV"] ||= "development" unless Object.const_defined?("MACK_ENV")
  MACK_ROOT = FileUtils.pwd unless Object.const_defined?("MACK_ROOT")
  require File.join(MACK_ROOT, "config", "boot.rb")
end

desc "Loads an irb console allow you full access to the application w/o a browser."
task :console do
  libs = []
  libs << "-r irb/completion"
  libs << "-r #{File.join(File.dirname(__FILE__), '..', 'mack')}"
  libs << "-r #{File.join(File.dirname(__FILE__), '..', 'initialization', 'console')}"
  exec "irb #{libs.join(" ")} --simple-prompt"
end

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
  end
  
end
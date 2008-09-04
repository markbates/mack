require 'mack-facets'
require 'application_configuration'
require File.join(File.dirname(__FILE__), 'boot_loader')
require File.join(File.dirname(__FILE__), '..', 'utils', 'paths')
boot_load(:configuration) do
  module Mack
  
    # Returns the root of the current Mack application
    def self.root
      ENV["MACK_ROOT"] ||= FileUtils.pwd
    end
  
    # Returns the environment of the current Mack application
    def self.env
      ENV["MACK_ENV"] ||= "development"
    end
  
    # All configuration for the Mack subsystem happens here. Each of the default environments,
    # production, development, and test have their own default configuration options. These
    # get merged with overall default options.
    module Configuration # :nodoc:

      class << self
        attr_accessor :initialized_core
        attr_accessor :initialized_application
      end

      # use local memory and store stuff for 24 hours:
      # use file for sessions and store them for 4 hours: 
      DEFAULTS_PRODUCTION = {
        "mack::use_lint" => false,
        "mack::show_exceptions" => false,
        "log_level" => "info",
        "log::detailed_requests" => false
      } unless self.const_defined?("DEFAULTS_PRODUCTION")
    
      # use local memory and store stuff for 5 minutes:
      DEFAULTS_DEVELOPMENT = {
        "mack::cache_classes" => false,
        "log_level" => "debug"
      } unless self.const_defined?("DEFAULTS_DEVELOPMENT")
    
      # use local memory and store stuff for 1 hour:
      DEFAULTS_TEST = {
        "log_level" => "error",
        "run_remote_tests" => true,
        "mack::cookie_values" => {},
        "mack::session_store" => "test"
      } unless self.const_defined?("DEFAULTS_TEST")
    
      unless self.const_defined?("DEFAULTS")
        DEFAULTS = {
          "mack::render_url_timeout" => 5,
          "mack::cache_classes" => true,
          "mack::use_lint" => true,
          "mack::show_exceptions" => true,
          "mack::use_sessions" => true,
          "mack::session_id" => "_mack_session_id",
          "mack::cookie_values" => {
            "path" => "/"
          },
          "mack::site_domain" => "http://localhost:3000",
          "mack::testing_framework" => "rspec",
          "mack::rspec_file_pattern" => "test/**/*_spec.rb",
          "mack::test_case_file_pattern" => "test/**/*_test.rb",
          "log::detailed_requests" => true,
          "log::db_color" => "cyan",
          "log::error_color" => "red",
          "log::fatal_color" => "red",
          "log::warn_color" => "yellow",
          "log::completed_color" => "purple",
          "log_level" => "info",
          "mack::session_store" => "cookie",
          "cookie_session_store::expiry_time" => 4.hours
        }#.merge(eval("DEFAULTS_#{Mack.env.upcase}"))
      end
    
      app_config.load_hash(DEFAULTS, "mack_defaults")
      app_config.load_hash(eval("DEFAULTS_#{Mack.env.upcase}"), "mack_defaults_#{Mack.env}")
      app_config.load_file(Mack::Paths.app_config("default.yml"))
      app_config.load_file(Mack::Paths.app_config("#{Mack.env}.yml"))
      # app_config.reload
    
      def self.dump
        fcs = app_config.instance.instance_variable_get("@final_configuration_settings")
        conf = {}
        fcs.each_pair do |k, v|
          unless v.is_a?(Application::Configuration::Namespace)
            conf[k.to_s] = v unless k.to_s.match("__")
          end
        end
        conf
      end
    
    end
  end
end
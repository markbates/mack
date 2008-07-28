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
      "log::detailed_requests" => false,
      "cachetastic_caches_mack_session_cache_options" => {
        "debug" => false,
        "adapter" => "file",
        "store_options" => 
          {"dir" => File.join(Mack.root, "tmp")},
        "expiry_time" => 14400,
        "logging" => {
          "logger_1" => {
            "type" => "file",
            "file" => File.join(Mack.root, "log", "cachetastic_caches_mack_session_cache.log")
          }
        }
      }
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
      "mack::drb_timeout" => 0,
      "mack::cookie_values" => {}
    } unless self.const_defined?("DEFAULTS_TEST")
    
    unless self.const_defined?("DEFAULTS")
      DEFAULTS = {
        "mack::render_url_timeout" => 5,
        "mack::cache_classes" => true,
        "mack::use_lint" => true,
        "mack::show_exceptions" => true,
        "mack::use_sessions" => true,
        "mack::session_id" => "_mack_session_id",
        "mack::rendering_systems" => [:action, :text, :partial, :public, :url, :xml],
        "mack::cookie_values" => {
          "path" => "/"
        },
        "cachetastic_default_options" => {
          "debug" => false,
          "adapter" => "local_memory",
          "expiry_time" => 300,
          "logging" => {
            "logger_1" => {
              "type" => "file",
              "file" => File.join(Mack.root, "log", "cachetastic.log")
            }
          }
        },
        "mack::site_domain" => "http://localhost:3000",
        "mack::use_distributed_routes" => false,
        "mack::distributed_app_name" => nil,
        "mack::distributed_site_domain" => "http://localhost:3000",
        "mack::drb_timeout" => 1,
        "mack::default_respository_name" => "default",
        "mack::testing_framework" => "rspec",
        "log::detailed_requests" => true,
        "log_level" => "info"
      }.merge(eval("DEFAULTS_#{Mack.env.upcase}"))
    end
    
    app_config.load_hash(DEFAULTS, "mack_defaults")
    app_config.load_file(File.join(Mack.root, "config", "app_config", "default.yml"))
    app_config.load_file(File.join(Mack.root, "config", "app_config", "#{Mack.env}.yml"))
    # app_config.reload
    
  end
end
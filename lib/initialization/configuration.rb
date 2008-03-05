module Mack
  # All configuration for the Mack subsystem happens here. Each of the default environments,
  # production, development, and test have their own default configuration options. These
  # get merged with overall default options.
  module Configuration # :nodoc:

    # use local memory and store stuff for 24 hours:
    # use file for sessions and store them for 4 hours: 
    DEFAULTS_PRODUCTION = {
      "mack::use_lint" => false,
      "mack::show_exceptions" => false,
      "mack::page_cache" => true,
      "log::level" => "info",
      "log::detailed_requests" => false,
      "cachetastic_default_options" => {
        "debug" => false,
        "adapter" => "local_memory",
        "expiry_time" => 86400,
        "logging" => {
          "logger_1" => {
            "type" => "file",
            "file" => File.join(MACK_ROOT, "log", "cachetastic.log")
          }
        }
      },
      "cachetastic_caches_mack_session_cache_options" => {
        "debug" => false,
        "adapter" => "file",
        "store_options" => 
          {"dir" => File.join(MACK_ROOT, "tmp")},
        "expiry_time" => 14400,
        "logging" => {
          "logger_1" => {
            "type" => "file",
            "file" => File.join(MACK_ROOT, "log", "cachetastic.log")
          }
        }
      }
    } unless self.const_defined?("DEFAULTS_PRODUCTION")
    
    # use local memory and store stuff for 5 minutes:
    DEFAULTS_DEVELOPMENT = {
      "mack::cache_classes" => false,
      "log::level" => "debug",
      "log::console" => true,
      "cachetastic_default_options" => {
        "debug" => false,
        "adapter" => "local_memory",
        "expiry_time" => 300,
        "logging" => {
          "logger_1" => {
            "type" => "file",
            "file" => File.join(MACK_ROOT, "log", "cachetastic.log")
          }
        }
      }
    } unless self.const_defined?("DEFAULTS_DEVELOPMENT")
    
    # use local memory and store stuff for 1 hour:
    DEFAULTS_TEST = {
      "log::level" => "error",
      "cachetastic_default_options" => {
        "debug" => false,
        "adapter" => "local_memory",
        "expiry_time" => 3600,
        "logging" => {
          "logger_1" => {
            "type" => "file",
            "file" => File.join(MACK_ROOT, "log", "cachetastic.log")
          }
        }
      }
    } unless self.const_defined?("DEFAULTS_TEST")
    
    unless self.const_defined?("DEFAULTS")
      DEFAULTS = {
        "mack::cache_classes" => true,
        "mack::use_lint" => true,
        "mack::show_exceptions" => true,
        "mack::page_cache" => false,
        "mack::session_id" => "_mack_session_id",
        "mack::cookie_values" => {
          "path" => "/"
        },
        # "mack::orm" => "activerecord",
        "log::detailed_requests" => true,
        "log::level" => "info",
        "log::console" => false,
        "log::file" => true,
        "log::console_format" => "%l:\t[%d]\t%M",
        "log::file_format" => "%l:\t[%d]\t%M"
      }.merge(eval("DEFAULTS_#{MACK_ENV.upcase}"))
    end
    
    app_config.load_hash(DEFAULTS, "mack_defaults")
    app_config.load_file(File.join(MACK_CONFIG, "app_config", "default.yml"))
    app_config.load_file(File.join(MACK_CONFIG, "app_config", "#{MACK_ENV}.yml"))
    # app_config.reload
    
  end
end
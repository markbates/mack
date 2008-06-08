module Mack
  
  # All configuration for the Mack subsystem happens here. Each of the default environments,
  # production, development, and test have their own default configuration options. These
  # get merged with overall default options.
  module Configuration # :nodoc:

    def self.env
      ENV["_mack_env"] ||= ENV["MACK_ENV"]
    end
    

    def self.method_missing(sym, *args)
      ev = "_mack_#{sym}".downcase
      return ENV[ev]
    end
    
    def self.set(name, value)
      ENV["_mack_#{name.to_s.downcase}"] = value
    end
    
    self.set(:env, "development") if self.env.nil?
    self.set(:root, FileUtils.pwd) if self.root.nil?
    self.set(:public_directory, File.join(self.root, "public")) if self.public_directory.nil?
    self.set(:app_directory, File.join(self.root, "app")) if self.app_directory.nil?
    self.set(:lib_directory, File.join(self.root, "lib")) if self.lib_directory.nil?
    self.set(:config_directory, File.join(self.root, "config")) if self.config_directory.nil?
    self.set(:views_directory, File.join(self.app_directory, "views")) if self.views_directory.nil?
    self.set(:layouts_directory, File.join(self.views_directory, "layouts")) if self.layouts_directory.nil?
    self.set(:plugins, File.join(self.root, "vendor", "plugins")) if self.plugins.nil?

    

    # use local memory and store stuff for 24 hours:
    # use file for sessions and store them for 4 hours: 
    DEFAULTS_PRODUCTION = {
      "mack::use_lint" => false,
      "mack::show_exceptions" => false,
      "log::level" => "info",
      "log::detailed_requests" => false,
      "cachetastic_caches_mack_session_cache_options" => {
        "debug" => false,
        "adapter" => "file",
        "store_options" => 
          {"dir" => File.join(Mack::Configuration.root, "tmp")},
        "expiry_time" => 14400,
        "logging" => {
          "logger_1" => {
            "type" => "file",
            "file" => File.join(Mack::Configuration.root, "log", "cachetastic_caches_mack_session_cache.log")
          }
        }
      }
    } unless self.const_defined?("DEFAULTS_PRODUCTION")
    
    # use local memory and store stuff for 5 minutes:
    DEFAULTS_DEVELOPMENT = {
      "mack::cache_classes" => false,
      "log::level" => "debug",
      "log::console" => true,
    } unless self.const_defined?("DEFAULTS_DEVELOPMENT")
    
    # use local memory and store stuff for 1 hour:
    DEFAULTS_TEST = {
      "log::level" => "error",
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
              "file" => File.join(Mack::Configuration.root, "log", "cachetastic.log")
            }
          }
        },
        "mack::site_domain" => "http://localhost:3000",
        "mack::use_distributed_routes" => false,
        "mack::distributed_app_name" => nil,
        "mack::distributed_site_domain" => "http://localhost:3000",
        "mack::drb_timeout" => 1,
        "mack::default_respository_name" => "default",
        "log::detailed_requests" => true,
        "log::level" => "info",
        "log::console" => false,
        "log::file" => true,
        "log::console_format" => "%l:\t[%d]\t%M",
        "log::file_format" => "%l:\t[%d]\t%M"
      }.merge(eval("DEFAULTS_#{Mack::Configuration.env.upcase}"))
    end
    
    app_config.load_hash(DEFAULTS, "mack_defaults")
    app_config.load_file(File.join(Mack::Configuration.config_directory, "app_config", "default.yml"))
    app_config.load_file(File.join(Mack::Configuration.config_directory, "app_config", "#{Mack::Configuration.env}.yml"))
    # app_config.reload
    
  end
end
require 'mack-facets'
require 'configatron'
require File.join(File.dirname(__FILE__), 'boot_loader')
require File.join(File.dirname(__FILE__), '..', 'core_extensions', 'kernel')
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
    
    # Returns true/false based on whether the specified environment
    # is the current environment
    def self.env?(env)
      self.env == env.to_s
    end
  
    # All configuration for the Mack subsystem happens here. Each of the default environments,
    # production, development, and test have their own default configuration options. These
    # get merged with overall default options.
    module Configuration # :nodoc:
      unless const_defined?("LOADED")
        configatron.mack.render_url_timeout = 5
        configatron.mack.cache_classes = true
        configatron.mack.reload_classes = 1
        configatron.mack.deep_class_reload = false
        configatron.mack.use_lint = true
        configatron.mack.show_exceptions = true
        configatron.mack.use_sessions = true
        configatron.mack.session_id = '_mack_session_id'
        configatron.mack.cookie_values = {:path => '/'}
        configatron.mack.site_domain = 'http://localhost:3000'
        configatron.mack.testing_framework = :rspec
        configatron.mack.rspec_file_pattern = 'test/**/*_spec.rb'
        configatron.mack.test_case_file_pattern = 'test/**/*_test.rb'
        configatron.mack.session_store = :cookie
        configatron.mack.disable_forgery_detector = false
        configatron.mack.assets.max_distribution = 4
        configatron.mack.assets.hosts = ''
        configatron.mack.assets.stamp = Time.now.to_i
        configatron.mack.cookie_session_store.expiry_time = 4.hours
        
        configatron.mack.log.level = :info
        configatron.mack.log.detailed_requests = true
        configatron.mack.log.disable_initialization_logging = false
        configatron.mack.log.root = Mack::Paths.log
        configatron.mack.log.colors.db = :cyan
        configatron.mack.log.colors.error = :red
        configatron.mack.log.colors.fatal = :red
        configatron.mack.log.colors.warn = :yellow
        configatron.mack.log.colors.completed = :purple
        configatron.mack.log.use_colors = true
        configatron.mack.log.time_format = '%Y-%m-%d %H:%M:%S'
      
        if Mack.env?(:production)
          configatron.mack.use_lint = false
          configatron.mack.show_exceptions = false
          configatron.mack.log.level = :info
          configatron.mack.log.detailed_requests = true
          configatron.mack.log.use_colors = false
        end
      
        if Mack.env?(:development)
          configatron.mack.cache_classes = false
          configatron.mack.log.level = :debug
        end

        if Mack.env?(:test)
          configatron.mack.cookie_values = {}
          configatron.mack.session_store = :test
          configatron.mack.disable_forgery_detector = true
          configatron.mack.run_remote_tests = true
          configatron.mack.log.level = :error
        end

        if File.exists?(Mack::Paths.configatron('default.rb'))
          require Mack::Paths.configatron('default.rb')
        end
      
        if File.exists?(Mack::Paths.configatron("#{Mack.env}.rb"))
          require Mack::Paths.configatron("#{Mack.env}.rb")
        end
    
        def self.dump
          configatron.inspect
        end
        
        LOADED = true
        
      end
    
    end
  end
end
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
  
    # All configuration for the Mack subsystem happens here. Each of the default environments,
    # production, development, and test have their own default configuration options. These
    # get merged with overall default options.
    module Configuration # :nodoc:

      configatron do |c|
        c.namespace(:mack) do |mack|
          mack.render_url_timeout = 5
          mack.cache_classes = true
          mack.use_lint = true
          mack.show_exceptions = true
          mack.use_sessions = true
          mack.session_id = '_mack_session_id'
          mack.cookie_values = {:path => '/'}
          mack.site_domain = 'http://localhost:3000'
          mack.testing_framework = :rspec
          mack.rspec_file_pattern = 'test/**/*_spec.rb'
          mack.test_case_file_pattern = 'test/**/*_test.rb'
          mack.session_store = :cookie
          mack.disable_forgery_detector = false
          mack.namespace(:assets) do |assets|
            assets.max_distribution = 4
            assets.hosts = ''
          end
        end
        c.namespace(:log) do |log|
          log.level = :info
          log.detailed_requests = true
          log.db_color = :cyan
          log.error_color = :red
          log.fatal_color = :red
          log.warn_color = :yellow
          log.completed_color = :purple
          log.disable_initialization_logging = false
          log.root = Mack::Paths.log
        end
        c.namespace(:cookie_session_store) do |css|
          css.expiry_time = 4.hours
        end
      end      
      
      if Mack.env == 'production'
        configatron do |c|
          c.namespace(:mack) do |mack|
            mack.use_lint = false
            mack.show_exceptions = false
          end
          c.namespace(:log) do |log|
            log.level = :info
            log.detailed_requests = true
          end
        end
      end
      
      if Mack.env == 'development'
        configatron do |c|
          c.namespace(:mack) do |mack|
            mack.cache_classes = true
          end
          c.namespace(:log) do |log|
            log.level = :debug
          end
        end
      end

      if Mack.env == 'test'
        configatron do |c|
          c.namespace(:mack) do |mack|
            mack.cookie_values = {}
            mack.session_store = :test
            mack.disable_forgery_detector = true
          end
          c.namespace(:log) do |log|
            log.level = :error
          end
          c.run_remote_tests = true
        end
      end

      if File.exists?(Mack::Paths.configatron('default.rb'))
        require Mack::Paths.configatron('default.rb')
      end
      
      if File.exists?(Mack::Paths.configatron("#{Mack.env}.rb"))
        require Mack::Paths.configatron("#{Mack.env}.rb")
      end
    
      def self.dump
        configatron.to_hash
      end
    
    end
  end
end
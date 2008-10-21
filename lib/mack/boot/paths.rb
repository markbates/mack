require 'fileutils'
run_once do
  
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
    
    def self.base_path(key)
      if $__mack_base_path.nil?
        $__mack_base_path = {}
      end
      path = Mack.root
      path = $__mack_base_path[key.to_sym] if $__mack_base_path.has_key?(key.to_sym)
      path
    end
    
    def self.set_base_path(key, value = "")
      if $__mack_base_path.nil?
        $__mack_base_path = {}
      end
      return if key == :local
      Mack.logger.warn "Base path for #{key} will be overwritten with #{value}" if $__mack_base_path.has_key?(key.to_sym)
      $__mack_base_path[key.to_sym] = value
    end
    
    def self.search_path(key, mack_paths_value = true)
      if $__mack_search_path.nil?
        $__mack_search_path = {}
      end
      paths = ($__mack_search_path[key.to_sym] ||= []).dup
      paths << Mack::Paths.send(key) if Mack::Paths.methods.include?(key.to_s) && mack_paths_value
      paths.flatten.uniq
    end
    
    def self.search_path_local_first(key)
      paths = []
      paths << Mack::Paths.send(key) if Mack::Paths.methods.include?(key.to_s)
      paths << self.search_path(key, false)
      paths.flatten.uniq
    end

    def self.add_search_path(key, path)
      if $__mack_search_path.nil?
        $__mack_search_path = {}
      end
      paths = ($__mack_search_path[key.to_sym] ||= [])
      paths << File.expand_path(path)
      $__mack_search_path[key.to_sym] = paths
    end
    
    module Paths

      # <MACK_PROJECT_ROOT>
      def self.root(*files)
        File.expand_path(File.join(Mack.root, *files))
      end

      # <MACK_PROJECT_ROOT>/public
      def self.public(*files)
        Mack::Paths.root("public", *files)
      end

      # <MACK_PROJECT_ROOT>/public/images
      def self.images(*files)
        Mack::Paths.public("images", *files)
      end

      # <MACK_PROJECT_ROOT>/public/javascripts
      def self.javascripts(*files)
        Mack::Paths.public("javascripts", *files)
      end

      # <MACK_PROJECT_ROOT>/public/stylesheets
      def self.stylesheets(*files)
        Mack::Paths.public("stylesheets", *files)
      end

      # <MACK_PROJECT_ROOT>/app
      def self.app(*files)
        Mack::Paths.root("app", *files)
      end

      # <MACK_PROJECT_ROOT>/log
      def self.log(*files)
        Mack::Paths.root("log", *files)
      end

      # <MACK_PROJECT_ROOT>/test
      def self.test(*files)
        Mack::Paths.root("test", *files)
      end

      # <MACK_PROJECT_ROOT>/tmp
      def self.tmp(*files)
        Mack::Paths.root("tmp", *files)
      end

      # <MACK_PROJECT_ROOT>/test/models
      def self.model_tests(*files)
        Mack::Paths.test("models", *files)
      end

      # <MACK_PROJECT_ROOT>/test/controllers
      def self.controller_tests(*files)
        Mack::Paths.test("controllers", *files)
      end

      def self.test_helpers(*files)
        Mack::Paths.test("helpers", *files)
      end

      # <MACK_PROJECT_ROOT>/test/helpers/controllers
      def self.controller_helper_tests(*files)
        Mack::Paths.test_helpers("controllers", *files)
      end

      # <MACK_PROJECT_ROOT>/test/helpers/views
      def self.view_helper_tests(*files)
        Mack::Paths.test_helpers("views", *files)
      end

      # <MACK_PROJECT_ROOT>/app/views
      def self.views(*files)
        Mack::Paths.app("views", *files)
      end

      # <MACK_PROJECT_ROOT>/app/views/layouts
      def self.layouts(*files)
        Mack::Paths.views("layouts", *files)
      end

      # <MACK_PROJECT_ROOT>/app/controllers
      def self.controllers(*files)
        Mack::Paths.app("controllers", *files)
      end

      # <MACK_PROJECT_ROOT>/app/models
      def self.models(*files)
        Mack::Paths.app("models", *files)
      end

      # <MACK_PROJECT_ROOT>/app/helpers
      def self.helpers(*files)
        Mack::Paths.app("helpers", *files)
      end

      # <MACK_PROJECT_ROOT>/app/helpers/controllers
      def self.controller_helpers(*files)
        Mack::Paths.helpers("controllers", *files)
      end

      # <MACK_PROJECT_ROOT>/app/helpers/views
      def self.view_helpers(*files)
        Mack::Paths.helpers("views", *files)
      end

      # <MACK_PROJECT_ROOT>/lib
      def self.lib(*files)
        Mack::Paths.root("lib", *files)
      end

      # <MACK_PROJECT_ROOT>/lib/tasks
      def self.tasks(*files)
        Mack::Paths.lib("tasks", *files)
      end

      # <MACK_PROJECT_ROOT>/db
      def self.db(*files)
        Mack::Paths.root("db", *files)
      end

      # <MACK_PROJECT_ROOT>/db/migrations
      def self.migrations(*files)
        Mack::Paths.db("migrations", *files)
      end

      # <MACK_PROJECT_ROOT>/config
      def self.config(*files)
        Mack::Paths.root("config", *files)
      end

      # <MACK_PROJECT_ROOT>/config/configatron
      def self.configatron(*files)
        Mack::Paths.config("configatron", *files)
      end

      # <MACK_PROJECT_ROOT>/config/initializers
      def self.initializers(*files)
        Mack::Paths.config("initializers", *files)
      end

      # <MACK_PROJECT_ROOT>/vendor
      def self.vendor(*files)
        Mack::Paths.root("vendor", *files)
      end

      # <MACK_PROJECT_ROOT>/vendor/plugins
      def self.plugins(*files)
        Mack::Paths.vendor("plugins", *files)
      end
      
      # <MACK_PROJECT_ROOT>/tmp/portlet_package
      def self.portlet_package(*files)
        Mack::Paths.tmp('portlet_package', *files)
      end
      
      # <MACK_PROJECT_ROOT>/portlet_config
      def self.portlet_config(*files)
        Mack::Paths.root('portlet_config', *files)
      end
      
      # <MACK_PROJECT_ROOT>/bin
      def self.bin(*files)
        Mack::Paths.root('bin', *files)
      end

    end # Paths
  end # Mack
  
end # run_once
module Mack
  module Paths
    
    # <MACK_PROJECT_ROOT>
    def self.root(*files)
      File.join(Mack.root, files)
    end
    
    # <MACK_PROJECT_ROOT>/public
    def self.public(*files)
      Mack::Paths.root("public", files)
    end
    
    # <MACK_PROJECT_ROOT>/public/images
    def self.images(*files)
      Mack::Paths.public("images", files)
    end
    
    # <MACK_PROJECT_ROOT>/public/javascripts
    def self.javascripts(*files)
      Mack::Paths.public("javascripts", files)
    end
    
    # <MACK_PROJECT_ROOT>/public/stylesheets
    def self.stylesheets(*files)
      Mack::Paths.public("stylesheets", files)
    end
    
    # <MACK_PROJECT_ROOT>/app
    def self.app(*files)
      Mack::Paths.root("app", files)
    end
    
    # <MACK_PROJECT_ROOT>/log
    def self.log(*files)
      Mack::Paths.root("log", files)
    end
    
    # <MACK_PROJECT_ROOT>/test
    def self.test(*files)
      Mack::Paths.root("test", files)
    end
    
    # <MACK_PROJECT_ROOT>/tmp
    def self.tmp(*files)
      Mack::Paths.root("tmp", files)
    end
        
    # <MACK_PROJECT_ROOT>/test/models
    def self.model_tests(*files)
      Mack::Paths.test("models", files)
    end
    
    # <MACK_PROJECT_ROOT>/test/controllers
    def self.controller_tests(*files)
      Mack::Paths.test("controllers", files)
    end
    
    def self.test_helpers(*files)
      Mack::Paths.test("helpers", files)
    end
    
    # <MACK_PROJECT_ROOT>/test/helpers/controllers
    def self.controller_helper_tests(*files)
      Mack::Paths.test_helpers("controllers", files)
    end
    
    # <MACK_PROJECT_ROOT>/test/helpers/views
    def self.view_helper_tests(*files)
      Mack::Paths.test_helpers("views", files)
    end
    
    # <MACK_PROJECT_ROOT>/app/views
    def self.views(*files)
      Mack::Paths.app("views", files)
    end
    
    # <MACK_PROJECT_ROOT>/app/views/layouts
    def self.layouts(*files)
      Mack::Paths.views("layouts", files)
    end
    
    # <MACK_PROJECT_ROOT>/app/controllers
    def self.controllers(*files)
      Mack::Paths.app("controllers", files)
    end
    
    # <MACK_PROJECT_ROOT>/app/models
    def self.models(*files)
      Mack::Paths.app("models", files)
    end
    
    # <MACK_PROJECT_ROOT>/app/helpers
    def self.helpers(*files)
      Mack::Paths.app("helpers", files)
    end
    
    # <MACK_PROJECT_ROOT>/app/helpers/controllers
    def self.controller_helpers(*files)
      Mack::Paths.helpers("controllers", files)
    end
    
    # <MACK_PROJECT_ROOT>/app/helpers/views
    def self.view_helpers(*files)
      Mack::Paths.helpers("views", files)
    end

    # <MACK_PROJECT_ROOT>/lib
    def self.lib(*files)
      Mack::Paths.root("lib", files)
    end
    
    # <MACK_PROJECT_ROOT>/lib/tasks
    def self.tasks(*files)
      Mack::Paths.lib("tasks", files)
    end
    
    # <MACK_PROJECT_ROOT>/db
    def self.db(*files)
      Mack::Paths.root("db", files)
    end
    
    # <MACK_PROJECT_ROOT>/db/migrations
    def self.migrations(*files)
      Mack::Paths.db("migrations", files)
    end
    
    # <MACK_PROJECT_ROOT>/config
    def self.config(*files)
      Mack::Paths.root("config", files)
    end
    
    # <MACK_PROJECT_ROOT>/config/app_config
    def self.app_config(*files)
      Mack::Paths.config("app_config", files)
    end
    
    # <MACK_PROJECT_ROOT>/config/initializers
    def self.initializers(*files)
      Mack::Paths.config("initializers", files)
    end
    
    # <MACK_PROJECT_ROOT>/vendor
    def self.vendor(*files)
      Mack::Paths.root("vendor", files)
    end
    
    # <MACK_PROJECT_ROOT>/vendor/plugins
    def self.plugins(*files)
      Mack::Paths.vendor("plugins", files)
    end
    
  end # Paths
end # Mack
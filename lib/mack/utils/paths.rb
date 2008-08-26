module Mack
  module Paths
    
    # <MACK_PROJECT_ROOT>
    def self.root(*files)
      File.join(Mack.root, files)
    end
    
    # <MACK_PROJECT_ROOT>/public
    def self.public(*files)
      File.join(Mack.root, "public", files)
    end
    
    # <MACK_PROJECT_ROOT>/public/images
    def self.images(*files)
      File.join(Mack::Paths.public, "images", files)
    end
    
    # <MACK_PROJECT_ROOT>/public/javascripts
    def self.javascripts(*files)
      File.join(Mack::Paths.public, "javascripts", files)
    end
    
    # <MACK_PROJECT_ROOT>/public/stylesheets
    def self.stylesheets(*files)
      File.join(Mack::Paths.public, "stylesheets", files)
    end
    
    # <MACK_PROJECT_ROOT>/app
    def self.app(*files)
      File.join(Mack.root, "app", files)
    end
    
    # <MACK_PROJECT_ROOT>/log
    def self.log(*files)
      File.join(Mack.root, "log", files)
    end
    
    # <MACK_PROJECT_ROOT>/test
    def self.test(*files)
      File.join(Mack.root, "test", files)
    end
    
    # # <MACK_PROJECT_ROOT>/test/functional
    # def self.functional(*files)
    #   File.join(Mack::Paths.test, "functional", files)
    # end
    # 
    # # <MACK_PROJECT_ROOT>/test/unit
    # def self.unit(*files)
    #   File.join(Mack::Paths.test, "unit", files)
    # end
    
    # <MACK_PROJECT_ROOT>/test/models
    def self.model_tests(*files)
      File.join(Mack::Paths.test, "models", files)
    end
    
    # <MACK_PROJECT_ROOT>/test/controllers
    def self.controller_tests(*files)
      File.join(Mack::Paths.test, "controllers", files)
    end
    
    # <MACK_PROJECT_ROOT>/test/helpers/controllers
    def self.controller_helper_tests(*files)
      File.join(Mack::Paths.test, "helpers", "controllers", files)
    end
    
    # <MACK_PROJECT_ROOT>/test/helpers/views
    def self.view_helper_tests(*files)
      File.join(Mack::Paths.test, "helpers", "views", files)
    end
    
    # <MACK_PROJECT_ROOT>/app/views
    def self.views(*files)
      File.join(Mack::Paths.app, "views", files)
    end
    
    # <MACK_PROJECT_ROOT>/app/views/layouts
    def self.layouts(*files)
      File.join(Mack::Paths.views, "layouts", files)
    end
    
    # <MACK_PROJECT_ROOT>/app/controllers
    def self.controllers(*files)
      File.join(Mack::Paths.app, "controllers", files)
    end
    
    # <MACK_PROJECT_ROOT>/app/models
    def self.models(*files)
      File.join(Mack::Paths.app, "models", files)
    end
    
    # <MACK_PROJECT_ROOT>/app/helpers
    def self.helpers(*files)
      File.join(Mack::Paths.app, "helpers", files)
    end
    
    # <MACK_PROJECT_ROOT>/app/helpers/controllers
    def self.controller_helpers(*files)
      File.join(Mack::Paths.helpers, "controllers", files)
    end
    
    # <MACK_PROJECT_ROOT>/app/helpers/controllers
    def self.view_helpers(*files)
      File.join(Mack::Paths.helpers, "views", files)
    end

    # <MACK_PROJECT_ROOT>/lib
    def self.lib(*files)
      File.join(Mack.root, "lib", files)
    end
    
    # <MACK_PROJECT_ROOT>/lib/tasks
    def self.tasks(*files)
      File.join(Mack::Paths.lib, "tasks", files)
    end
    
    # <MACK_PROJECT_ROOT>/db
    def self.db(*files)
      File.join(Mack.root, "db", files)
    end
    
    # <MACK_PROJECT_ROOT>/db/migrations
    def self.migrations(*files)
      File.join(Mack::Paths.db, "migrations", files)
    end
    
    # <MACK_PROJECT_ROOT>/config
    def self.config(*files)
      File.join(Mack.root, "config", files)
    end
    
    # <MACK_PROJECT_ROOT>/config/app_config
    def self.app_config(*files)
      File.join(Mack::Paths.config, "app_config", files)
    end
    
    # <MACK_PROJECT_ROOT>/config/initializers
    def self.initializers(*files)
      File.join(Mack::Paths.config, "initializers", files)
    end
    
    # <MACK_PROJECT_ROOT>/vendor
    def self.vendor(*files)
      File.join(Mack.root, "vendor", files)
    end
    
    # <MACK_PROJECT_ROOT>/vendor/plugins
    def self.plugins(*files)
      File.join(Mack::Paths.vendor, "plugins", files)
    end
    
  end # Paths
end # Mack
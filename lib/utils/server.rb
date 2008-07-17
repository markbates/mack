module Mack
  module Utils
    module Server
    
      # This method wraps all the necessary components of the Rack system around
      # Mack::Runner. This can be used build your own server around the Mack framework.
      def self.build_app
        # Mack framework:
        app = Mack::Runner.new
        
        Mack::Utils::Server::Registry.instance.wrappers do |w|
          puts "Wrapping app with: #{w}"
          app = w.new(app)
        end
        
        # Any urls listed will go straight to the public directly and will not be served up via the app:
        app = Rack::Static.new(app, :urls => ["/css", "/images", "/files", "/images", "/stylesheets", "/javascripts", "/media"], :root => "public")
        app = Rack::Lint.new(app) if app_config.mack.use_lint 
        app = Rack::ShowStatus.new(app) 
        app = Rack::ShowExceptions.new(app) if app_config.mack.show_exceptions
        app = Rack::Recursive.new(app)
        # This will reload any edited classes if the cache_classes config setting is set to true.
        app = Rack::Reloader.new(app, 1) unless app_config.mack.cache_classes
        # TODO: Not sure about this logger, investigate better ones.
        # TODO: Depends on Mack.logger already being configured.
        # This makes it a drag run this 'standalone' in another Ruby program.
        # app = Rack::CommonLogger.new(app, Mack.logger)
        app
      end
      
      class Registry
        include Singleton
        
        attr_reader :wrappers
        
        def initialize
          @wrappers = []
        end
        
        def add(klass)
          @wrappers << klass
        end
        
      end
    
    end # Server
  end # Utils
end # Mack
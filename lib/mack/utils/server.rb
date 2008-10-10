module Mack
  module Utils

    # Houses a registry of Rack runners that should be called before the Mack::Runner.
    class RunnersRegistry < Mack::Utils::RegistryList
    end

    module Server

      # This method wraps all the necessary components of the Rack system around
      # Mack::Runner. This can be used build your own server around the Mack framework.
      def self.build_app
        # Mack framework:
        app = Mack::Runner.new

        Mack::Utils::RunnersRegistry.registered_items.each do |runner|
          app = runner.new(app)
        end

        # Any urls listed will go straight to the public directly and will not be served up via the app:
        Mack.search_path(:public).each do |path|
          app = Mack::Static.new(app, :urls =>  configatron.mack.static_paths, :root => path)
        end
        # app = Mack::Static.new(app)
        app = Mack::Utils::ContentLengthHandler.new(app)
        app = Rack::Lint.new(app) if configatron.mack.use_lint 
        app = Rack::ShowStatus.new(app) 
        app = Rack::ShowExceptions.new(app) if configatron.mack.show_exceptions
        app = Rack::Recursive.new(app)
        
        # This will reload any edited classes if the cache_classes config setting is set to true.
        app = Mack::Reloader.new(app) unless configatron.mack.cache_classes
        app
      end

    end # Server
  end # Utils
end # Mack
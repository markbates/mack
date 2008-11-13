module Mack
  module Routes
    
    private
    # See Mack::Routes for more information.
    class RouteMap
      include Singleton
      
      def initialize # :nodoc:
        reset!
      end
      
      def reset! # :nodoc:
        @_default_routes = []
        @_route_map = {:get => [], :post => [], :put => [], :delete => [], :errors => {}}
        @_deferred_route_map = {:get => [], :post => [], :put => [], :delete => [], :errors => {}}
      end
      
      def any? # :nodoc:
        @_route_map.each do |k, v|
          return true if v.any?
        end
        return false
      end
      
      def empty? # :nodoc:
        @_route_map.each do |k, v|
          return false if v.any?
        end
        return true
      end
      
      def retrieve(url_or_request, verb = :get) # :nodoc:
        path = url_or_request
        host = nil
        scheme = nil
        port = nil
        if url_or_request.is_a?(Mack::Request)
          path = url_or_request.path_info
          host = url_or_request.host
          scheme = url_or_request.scheme
          port = url_or_request.port
          verb = (url_or_request.params["_method"] || url_or_request.request_method.downcase).to_sym
        end
        path = path.dup
        format = (File.extname(path).blank? ? '.html' : File.extname(path))
        format = format[1..format.length]
        routes = @_route_map[verb]
        routes.each do |route|
          if route.match?(:uri => path, :host => host, :scheme => scheme, :port => port)
            ret_val = route.options_with_parameters(path, host)
            return ret_val
          end
        end
        @_default_routes.each do |route|
          if route.match?(:uri => path) && route.options[:method] == verb
            ret_val = route.options_with_parameters(path)
            return ret_val
          end
        end
        raise Mack::Errors::UndefinedRoute.new(path)
      end
      
      def retrieve_from_error(error) # :nodoc:
        @_route_map[:errors][error]
      end
      
      # Connects a url pattern to a controller, an action, and an HTTP verb.
      def connect(path, options = {}, &block)
        options = handle_options(options, &block)
        if path.is_a?(String)
          path = "/#{path}" unless path.match(/^\//)
        end
        route = RouteObject.new(path, options)
        @_route_map[options[:method]] << route
        @_deferred_route_map[options[:method]] << route if route.deferred
        route
      end
      
      def method_missing(sym, *args, &block) # :nodoc:
        connect_with_name(sym, *args, &block)
      end
      
      # Creates 'Rails' style default mappings:
      #   "/:controller/:action/:id"
      #   "/:controller/:action"
      # These get created for each of the 4 HTTP verbs.
      def defaults
        @_default_routes = []
        [:get, :post, :put, :delete].each do |verb|
          @_default_routes << RouteObject.new("/:controller/:action/:id", :method => verb)
          @_default_routes << RouteObject.new("/:controller/:action", :method => verb)
        end
      end
      
      def handle_error(error, options)
        @_route_map[:errors][error] = options
      end
      
      # Sets up mappings and named routes for a resource.
      def resource(controller, options = {}, &block)
        # yield up to add other resources:
        if block_given?
          proxy = ResourceProxy.new(controller, [controller.to_sym])
          yield proxy
          proxy.routes.each do |route|
            connect_with_name("#{controller}_#{route[:name]}", route[:path], options.merge(route[:options]))
          end
        end
        # connect the default resources:
        build_resource_routes(controller, controller, controller, options)
      end
      
      def inspect # :nodoc:
        @_route_map.inspect
      end
      
      def routes_list # :nodoc:
        @_route_map
      end
      
      def deferred_routes_list # :nodoc:
        @_deferred_route_map
      end
      
      def default_routes_list # :nodoc:
        @_default_routes || []
      end
      
      def connect_with_name(name, path, options = {}, &block) # :nodoc:
        n_route = name.methodize
        route = connect(path, {:action => n_route.to_sym}.merge(options), &block)
        
        Mack::Routes::Urls.create_method("#{n_route}_url") do |*options|
          options = *options
          options = {} if options.nil? || !options.is_a?(Hash)
          url_for_pattern(route.path, (route.options.reject{|k,v| k.to_sym == :action || k.to_sym == :controller || k.to_sym == :method}).merge(options))
        end
        
        Mack::Routes::Urls.create_method("#{n_route}_full_url") do |*options|
          options = *options
          options = {} if options.nil? || !options.is_a?(Hash)
          if @request
            options = {:host => @request.host, :scheme => @request.scheme, :port => @request.port}.merge(options)
          end
          self.send("#{n_route}_url", options)
        end        
      end
      
      def build_resource_routes(method_base, path_base, controller, options) # :nodoc:
        connect_with_name("#{method_base}_index", "/#{path_base}", {:controller => controller, :action => :index, :method => :get}.merge(options))
        connect_with_name("#{method_base}_create", "/#{path_base}", {:controller => controller, :action => :create, :method => :post}.merge(options))
        connect_with_name("#{method_base}_new", "/#{path_base}/new", {:controller => controller, :action => :new, :method => :get}.merge(options))
        connect_with_name("#{method_base}_show", "/#{path_base}/:id", {:controller => controller, :action => :show, :method => :get}.merge(options))
        connect_with_name("#{method_base}_edit", "/#{path_base}/:id/edit", {:controller => controller, :action => :edit, :method => :get}.merge(options))
        connect_with_name("#{method_base}_update", "/#{path_base}/:id", {:controller => controller, :action => :update, :method => :put}.merge(options))
        connect_with_name("#{method_base}_delete", "/#{path_base}/:id", {:controller => controller, :action => :delete, :method => :delete}.merge(options))
      end
      
      private
      def handle_options(opts, &block)
        opts = {:method => :get}.merge(opts.symbolize_keys)
        opts[:runner_block] = block if block_given?
        opts
      end
      
    end # RouteMap
    
  end # Routes
end # Mack

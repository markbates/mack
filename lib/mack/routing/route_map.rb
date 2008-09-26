module Mack
  # Routes are the back bone of the Mack framework. They are used to map incoming urls to controllers.
  #
  # === Defining Routes:
  # Example:
  #   Mack::Routes.build do |r|
  #
  #     # Connects "/" to the HomeController and the '/' action.
  #     r.connect "/", :controller => :home
  # 
  #     # Connects "/foo", to the HomeController and the 'foo' action.
  #     r.connect "/foo", :controller => :home, :action => :foo
  #
  #     # Connects "/blog" to the BlogController and the 'list' action.
  #     r.connect "/blog", :controller => :blog, :action => :list
  # 
  #     # Connects "/blog/:id" to the BlogController and the 'index' action.
  #     # It will also take the second half of the url and map it to a parameter called :id.
  #     # Example:
  #     #   '/blog/1' # => goes to the BlogController, 'index' action, and has an :id parameter == 1.
  #     r.connect "/blog/:id", :controller => :blog, :action => :index
  # 
  #     # Connects "/blog/create" to the BlogController and the 'create' action.
  #     # It also insists that the HTTP method be 'post'. If it's not 'post' it will not match this route.
  #     r.connect "/blog/create", :controller => :blog, :action => :create, :method => :post
  # 
  #     # Connects "/comment/destroy/:id" to the CommentController and the 'destroy' action.
  #     # It also insists that the HTTP method be 'delete'. If it's not 'delete' it will not match this route.
  #     # It will also create an :id parameter.
  #     r.connect "/comment/destroy/:id", :controller => :comment, :action => :destroy, :method => :delete
  #
  #     # This will create 'RESTful' routes. Unlike Rails, it doesn't generate a mixture of singular/plural
  #     # routes. It uses whatever you pass in to it. This will also create named routes in Mack::Routes::Urls.
  #     # Examples:
  #     #   '/users' # => {:controller => 'users', :action => :index, :method => :get} 
  #     #            # => users_index_url
  #     #            # => users_index_full_url
  #     #   '/users' # => {:controller => 'users', :action => :create, :method => :post} 
  #     #            # => users_create_url
  #     #            # => users_create_full_url
  #     #   '/users/new' # => {:controller => 'users', :action => :new, :method => :get} 
  #     #                # => users_new_url
  #     #                # => users_new_full_url
  #     #   '/users/:id' # => {:controller => 'users', :action => :show, :method => :get} 
  #     #                # => users_show_url
  #     #                # => users_show_full_url
  #     #   '/users/:id/:edit # => {:controller => 'users', :action => :edit, :method => :get} 
  #     #                     # => users_edit_url
  #     #                     # => users_edit_full_url
  #     #   '/users/:id # => {:controller => 'users', :action => :update, :method => :put} 
  #     #                      # => users_update_url
  #     #                      # => users_update_full_url
  #     #   '/users/:id # => {:controller => 'users', :action => :delete, :method => :delete} 
  #     #               # => users_delete_url
  #     #               # => users_delete_full_url
  #     r.resource :users
  # 
  #     # This will redirect '/old_users/show/:id' to '/users/:id' with a status of 302, 'Moved Temporarily'.
  #     # Examples:
  #     #   '/old_users/show/1' # => '/users/1' (status of 302)
  #     #   '/old_users/show/1?foo=bar' # => '/users/1?foo=bar' (status of 302)
  #     r.connect '/old_users/show/:id', :redirect_to => "/users/:id"
  # 
  #     # This will redirect '/old_blog' to '/blog' with a status of 301, 'Moved Permanently'.
  #     # Examples:
  #     #   '/old_blog' # => '/blog' (status of 301)
  #     #   '/old_blog?foo=bar' # => '/blogfoo=bar' (status of 301)
  #     r.connect '/old_blog', :redirect_to => "/blog", :status => 301
  # 
  #     # Connects "/comment/update/:id" to the CommentController and the 'update' action.
  #     # It will also create an :id parameter.
  #     # It will also create a named route in Mack::Routes::Urls called, 'c_u_url'.
  #     # In a controller or a view this: c_u_url(:id => 1) would return '/comment/update/1'.
  #     # It will also create a named route in Mack::Routes::Urls called, 'c_u_full_url'.
  #     # In a controller or a view this: c_u_full_url(:id => 1) would return 'http://example.org/comment/update/1'.
  #     r.c_u "/comment/update/:id", {:controller => :comment, :action => :update}
  #
  #     # This creates 'Rails' style routes.
  #     # Any requests that come in that aren't found by explicit routes, will fall into these routes.
  #     # '/:controller/:action'
  #     # '/:controller/:action/:id'
  #     #
  #     # Example:
  #     #   '/comment/show/1' # => Goes to CommentController, the 'show' action, with a parameter of 1.
  #     r.defaults
  #   
  #   end
  # 
  # === Named Routes:
  #   Mack::Routes.build do |r|
  #     r.resource :users
  #   end
  # See above in 'Defining Routes' to see what fully gets created when you map a resource, but let's look
  # at the named route stuff that gets generated. In particular let's look at one example:
  #   '/users/:id' # => {:controller => 'users', :action => :show, :method => :get} 
  #                # => users_show_url
  #                # => users_show_full_url
  # The following can be used in controllers, views, and tests:
  #   users_show_url(:id => 1) # => '/users/1'
  #   # The following can only be used when there is a @request (Mack::Request) instance variable around:
  #   users_show_full_url(:id => 1) # => 'http://example.org/users/1' 
  # 
  #   Mack::Routes.build do |r|
  #     r.hello_world "/", :controller => :home_page, :action => :hello
  #   end
  # This will give you the following two methods:
  #   hello_world_url # => "/"
  #   hello_world_full_url # => "http://example.org/"
  # These methods act just like the ones created when you use the resource method.
  # 
  # === Exception Routes:
  # You can define a route that will catch exceptions that are raised in other controllers.
  # 
  #   Mack::Routes.build do |r|
  #     r.handle_error Mack::ResourceNotFound, :controller => :oops, :action => :404
  #     r.handle_error HollyCrapError, :controller => :oops, :action => :500
  #   end
  # In the example if an action raises a Mack::ResourceNotFound it will be caught and rendered
  # using the OopsController and the 404 action.
  # If A HollyCrapError is thrown it will be caught and rendered using the OopsController and the 500 action.
  # You can catch all exceptions using Exception.
  module Routes
    include Extlib::Hook
    
    class << self
      
      # This method yields up Mack::Routes::RouteMap and allows for the creation of routes in the system.
      def build
        yield Mack::Routes::RouteMap.instance
        Mack::Routes::Urls.include_safely_into(Mack::Controller, 
                                               Mack::Rendering::ViewTemplate, 
                                               Test::Unit::TestCase)
      end
      
      def any?
        Mack::Routes::RouteMap.instance.any?
      end
      
      def empty?
        Mack::Routes::RouteMap.instance.empty?
      end
      
      def reset!
        Mack::Routes::RouteMap.instance.reset!
      end
      
      def retrieve(url_or_request, verb = :get)
        Mack::Routes::RouteMap.instance.retrieve(url_or_request, verb)
      end
      
      def retrieve_from_error(error)
        Mack::Routes::RouteMap.instance.retrieve_from_error(error)
      end
      
      def inspect
        Mack::Routes::RouteMap.instance.inspect
      end
      
    end
    
    private
    class RouteMap
      include Singleton
      
      def initialize
        reset!
      end
      
      def reset!
        @_default_routes = []
        @_route_map = {:get => [], :post => [], :put => [], :delete => [], :errors => {}}
      end
      
      def any?
        @_route_map.each do |k, v|
          return true if v.any?
        end
        return false
      end
      
      def empty?
        @_route_map.each do |k, v|
          return false if v.any?
        end
        return true
      end
      
      # Pass in a request or a String and it will try and give you back a Hash representing the 
      # options for that route. IE: controller, action, verb, etc...
      # If there are embedded options they added to the Hash. These parameters are
      # also added to the 'params' object in the request.
      # If the route can not be found a Mack::Errors::UndefinedRoute exception is raised.
      def retrieve(url_or_request, verb = :get)
        path = url_or_request
        host = nil
        scheme = nil
        if url_or_request.is_a?(Mack::Request)
          path = url_or_request.path_info
          host = url_or_request.host
          scheme = url_or_request.scheme
          verb = (url_or_request.params["_method"] || url_or_request.request_method.downcase).to_sym
        end
        path = path.dup
        format = (File.extname(path).blank? ? '.html' : File.extname(path))
        format = format[1..format.length]
        routes = @_route_map[verb]
        routes.each do |route|
          if route.options[:host]
            next unless route.options[:host].downcase == host
          end
          if route.options[:scheme]
            next unless route.options[:scheme].downcase == scheme
          end
          if route.match?(path)
            ret_val = route.options_with_parameters(path)
            return ret_val
          end
        end
        @_default_routes.each do |route|
          if route.match?(path) && route.options[:method] == verb
            ret_val = route.options_with_parameters(path)
            return ret_val
          end
        end
        raise Mack::Errors::UndefinedRoute.new(path)
      end
      
      # Given an error class name it will return a routing options Hash, or nil, if one
      # has not been mapped.
      def retrieve_from_error(error)
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
        route
      end
      
      def method_missing(sym, *args, &block)
        connect_with_name(sym, *args, &block)
      end
      
      # Creates 'Rails' style default mappings:
      #   "/:controller/:action/:id"
      #   "/:controller/:action"
      # These get created for each of the 4 HTTP verbs.
      def defaults
        [:get, :post, :put, :delete].each do |verb|
          @_default_routes << RouteObject.new("/:controller/:action/:id", :method => verb)
          @_default_routes << RouteObject.new("/:controller/:action", :method => verb)
        end
      end
      
      def handle_error(error, options)
        @_route_map[:errors][error] = options
      end
      
      # Sets up mappings and named routes for a resource.
      def resource(controller, &block)
        # yield up to add other resources:
        if block_given?
          proxy = ResourceProxy.new(controller)
          yield proxy
          proxy.routes.each do |route|
            connect_with_name("#{controller}_#{route[:name]}", route[:path], route[:options])
          end
        end
        # connect the default resources:
        connect_with_name("#{controller}_index", "/#{controller}", {:controller => controller, :action => :index, :method => :get})
        connect_with_name("#{controller}_create", "/#{controller}", {:controller => controller, :action => :create, :method => :post})
        connect_with_name("#{controller}_new", "/#{controller}/new", {:controller => controller, :action => :new, :method => :get})
        connect_with_name("#{controller}_show", "/#{controller}/:id", {:controller => controller, :action => :show, :method => :get})
        connect_with_name("#{controller}_edit", "/#{controller}/:id/edit", {:controller => controller, :action => :edit, :method => :get})
        connect_with_name("#{controller}_update", "/#{controller}/:id", {:controller => controller, :action => :update, :method => :put})
        connect_with_name("#{controller}_delete", "/#{controller}/:id", {:controller => controller, :action => :delete, :method => :delete})
      end
      
      def inspect
        @_route_map.inspect
      end
      
      private
      def connect_with_name(name, path, options = {}, &block)
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
      
      def handle_options(opts, &block)
        opts = {:method => :get}.merge(opts.symbolize_keys)
        opts[:runner_block] = block if block_given?
        opts
      end
      
    end # RouteMap
    
    class ResourceProxy
      
      attr_accessor :controller
      attr_accessor :routes
      
      def initialize(controller)
        self.controller = controller
        self.routes = []
      end
      
      def method_missing(sym, *args)
        connect(sym, *args)
      end
      
      private
      def connect(name, path, options = {})
        route = {}
        route[:name] = name.to_s.gsub(/^#{self.controller}/, '')
        route[:options] = {:controller => self.controller, :action => route[:name].to_sym, :method => :get}.merge(options)
        paths = path.split('/')
        paths.insert(0, self.controller.to_s)
        route[:path] = paths.reject{|m| m.blank?}.uniq.join('/')
        routes << route
      end
      
    end # ResourceProxy
    
    class RouteObject
      attr_accessor :options
      attr_accessor :path
      attr_accessor :regex_pattern
      attr_accessor :embedded_parameters
      attr_accessor :wildcard
      
      def initialize(path, options = {})
        self.path = path
        self.options = {:action => :index}.merge(options)
        self.embedded_parameters = []
        build_regex_pattern
      end
      
      def ==(other)
        self.options == other
      end
      
      def match?(url)
        if url.downcase.match(self.regex_pattern)
          if self.options[:format]
            format = (File.extname(url).blank? ? '.html' : File.extname(url))
            format = format[1..format.length]
            return format.to_sym == self.options[:format]
          end
          return true
        end
        return false
      end
      
      def options_with_parameters(url)
        format = (File.extname(url).blank? ? '.html' : File.extname(url))
        format = format[1..format.length]
        opts = self.options.merge(:format => format)
        url = url.gsub(/\.#{format}$/, '')
        if self.embedded_parameters.any?
          url.split('/').each_with_index do |seg, i|
            ep = self.embedded_parameters[i]
            unless ep.nil?
              opts[ep.to_sym] = seg
            end
          end
        end
        if self.wildcard
          caps = url.match(self.regex_pattern).captures
          if caps
            opts[self.wildcard.to_sym] = caps.first.split('/')
          end
        end

        opts
      end
      
      private
      def build_regex_pattern
        if self.path.is_a?(Regexp)
          self.regex_pattern = self.path
        elsif self.path.is_a?(String)
          reg = []
          if self.path == '/'
            self.regex_pattern = /^\/$/
          else
            self.path.split('/').each_with_index do |seg, i|
              if seg.match(/^:/)
                self.embedded_parameters[i] = seg.gsub(':', '')
                reg << '[^/]+'
              elsif seg.match(/^\*/)
                self.wildcard = seg.gsub('*', '')
                reg << '(.+)'
              else
                reg << seg.downcase
              end
            end
            self.regex_pattern = /^#{reg.join('/') + '(\..+$|$)'}/
          end
        else
          raise ArgumentError.new("'#{self.path}' is a #{self.path.class} and it should be either a String or Regexp!")
        end
      end
      
    end # RouteObject
    
  end # Routes
end # Mack

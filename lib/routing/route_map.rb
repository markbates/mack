module Mack
  
  module Routes
    
    # This method yields up Mack::Routes::RouteMap and allows for the creation of routes in the system.
    # 
    # See Mack::Routes::RouteMap for more information.
    def self.build
      yield Mack::Routes::RouteMap.instance
      Mack::Routes::Urls.include_safely_into(Mack::Controller::Base, 
                                             Mack::Rendering::ViewTemplate, 
                                             Test::Unit::TestCase, 
                                             Mack::Distributed::Routes::Urls)
      if app_config.mack.use_distributed_routes
        raise Mack::Distributed::Errors::ApplicationNameUndefined.new if app_config.mack.distributed_app_name.nil?
        
        d_urls = Mack::Distributed::Routes::Urls.new(app_config.mack.distributed_site_domain)
        d_urls.put
      end
      # puts "Finished compiling routes: #{Mack::Routes::RouteMap.instance.routes_list.inspect}"
    end
    
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
    class RouteMap
      include Singleton
      
      def initialize # :nodoc:
        @routes_list = []
        @default_routes_list = []
        @handle_error_routes = {}
      end
      
      # Creates 'Rails' style default mappings:
      #   "/:controller/:action/:id"
      #   "/:controller/:action"
      # These get created for each of the 4 HTTP verbs.
      def defaults
        @default_routes_list = []
        [:get, :post, :put, :delete].each do |verb|
          @default_routes_list << build_route("/:controller/:action/:id", :method => verb)
          @default_routes_list << build_route("/:controller/:action", :method => verb)
        end
      end
      
      # Connects a url pattern to a controller, an action, and an HTTP verb.
      def connect(pattern, options = {})
        route = build_route(pattern, options)
        routes_list << route
        return route
      end
      
      # Sets up mappings and named routes for a resource.
      def resource(controller)
        connect_with_named_route("#{controller}_index", "/#{controller}", {:controller => controller, :action => :index, :method => :get})
        connect_with_named_route("#{controller}_create", "/#{controller}", {:controller => controller, :action => :create, :method => :post})
        connect_with_named_route("#{controller}_new", "/#{controller}/new", {:controller => controller, :action => :new, :method => :get})
        connect_with_named_route("#{controller}_show", "/#{controller}/:id", {:controller => controller, :action => :show, :method => :get})
        connect_with_named_route("#{controller}_edit", "/#{controller}/:id/edit", {:controller => controller, :action => :edit, :method => :get})
        connect_with_named_route("#{controller}_update", "/#{controller}/:id", {:controller => controller, :action => :update, :method => :put})
        connect_with_named_route("#{controller}_delete", "/#{controller}/:id", {:controller => controller, :action => :delete, :method => :delete})
      end
      
      def handle_error(error, options = {})
        @handle_error_routes[error] = options
      end
      
      def method_missing(sym, *args) # :nodoc:
        connect_with_named_route(sym, args.first, args.last)
      end
      
      # Pass in a request and it will try and give you back a Hash representing the 
      # options for that route. IE: controller, action, verb, etc...
      # If there are embedded options they added to the Hash. These parameters are
      # also added to the 'params' object in the request.
      # If the route can not be found a Mack::Errors::UndefinedRoute exception is raised.
      def get_route_from_request(req)
        pattern = req.path_info.downcase
        unless pattern == "/"
          pattern.chop! if pattern.match(/\/$/)
        end
        meth = (req.params["_method"] || req.request_method.downcase).to_sym
        rt = routes_list.dup
        rt << @default_routes_list.dup
        rt.flatten!
        begin
          rt.each do |route|
            if pattern.match(route.regex_pattern) && route.method == meth
              r = route
              opts = r.options_with_embedded_parameters(pattern)
              req.merge_params(opts)
              return opts
            end
          end
        rescue Exception => e
          raise e
        end
        # Can't find the route!
        raise Mack::Errors::UndefinedRoute.new(req)
      end # get
      
      # Given an error class name it will return a routing options Hash, or nil, if one
      # has not been mapped.
      def get_route_from_error(error)
        @handle_error_routes[error]
      end
      
      attr_reader :routes_list # :nodoc:
      
      private
      def build_route(pattern, options = {})
        # set the default options:
        options = {:action => :index, :method => :get}.merge(options)
        meth = options[:method].to_sym
        # if the pattern doesn't start with /, then add it.
        pattern = "/" << pattern unless pattern.match(/^\//)
        pt = pattern.downcase
        route = Route.new(pt, regex_from_pattern(pt), meth, options)
        route
      end
      
      def connect_with_named_route(n_route, pattern, options = {})
        n_route = n_route.methodize
        route = connect(pattern, options)
        
        url = %{
          def #{n_route}_url(options = {})
            url_for_pattern("#{route.original_pattern}", options)
          end
          
          def #{n_route}_full_url(options = {})
            u = #{n_route}_url(options)
            "\#{@request.full_host}\#{u}"
          end
        }
        
        Mack::Routes::Urls.class_eval(url)
        
        if app_config.mack.use_distributed_routes
          
          Mack::Routes::Urls.class_eval %{
            def #{n_route}_distributed_url(options = {})
              (@dsd || app_config.mack.distributed_site_domain) + #{n_route}_url(options)
            end
          }
        end
      end
      
      def regex_from_pattern(pattern)
        pattern.chop! if pattern.match(/\/$/)
        segs = []
        sections = pattern.split("/")
        sections.each_with_index do |sec, ind|
          if sec.match(/\A:/)
            segs << "[^/]+"
          else
            segs << sec
          end
        end
        s = segs.join("/")
        s = "/" if s.blank?
        if s.match(".:format")
          s.gsub!(/\.:format/, "(\\..+|$)")
        else
          s << "(\\..+|$)"
        end
        
        rx = /^#{s}$/
        rx
      end # regex_from_pattern
      
      class Route # :nodoc:
        attr_accessor :regex_pattern
        attr_accessor :method
        attr_accessor :original_pattern
        attr_accessor :options
        attr_accessor :embedded_parameters
        
        def initialize(original_pattern, regex_pattern, method, options)
          self.original_pattern = original_pattern
          self.regex_pattern = regex_pattern
          self.method = method
          self.options = options
          self.embedded_parameters = []
          # find out where the embedded_parameters are:
          original_pattern.split("/").each_with_index do |seg, ind|
            if seg.match(/^:/)
              self.embedded_parameters[ind] = seg[1..seg.length].to_sym
            end
          end
        end
        
        def options_with_embedded_parameters(uri)
          opts = {:format => :html}.merge(self.options)
          m = uri.match(/\..+$/)
          if m
            m = m.to_s
            opts[:format]= m[1..m.size].to_sym
            uri.gsub!(/\..+$/, "")
          end
          split_uri = uri.split("/")
          self.embedded_parameters.each_with_index do |val, ind|
            unless val.nil?
              opts[val] = split_uri[ind]
            end
          end
          opts
        end
        
      end # Route
      
    end # RouteMap

  end # Routes
  
end # Mack
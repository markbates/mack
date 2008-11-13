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
      
      # Pass in a request or a String and it will try and give you back a Hash representing the 
      # options for that route. IE: controller, action, verb, etc...
      # If there are embedded options they added to the Hash. These parameters are
      # also added to the 'params' object in the request.
      # If the route can not be found a Mack::Errors::UndefinedRoute exception is raised.
      def retrieve(url_or_request, verb = :get)
        Mack::Routes::RouteMap.instance.retrieve(url_or_request, verb)
      end
      
      # Given an error class name it will return a routing options Hash, or nil, if one
      # has not been mapped.
      def retrieve_from_error(error)
        Mack::Routes::RouteMap.instance.retrieve_from_error(error)
      end
      
      def inspect # :nodoc:
        Mack::Routes::RouteMap.instance.inspect
      end
      
      def deferred_routes_list # :nodoc:
        Mack::Routes::RouteMap.instance.deferred_routes_list
      end
      
    end
    
  end # Routes
end # Mack

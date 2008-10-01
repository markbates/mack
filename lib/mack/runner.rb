require File.join(File.dirname(__FILE__), 'routing', 'urls')
module Mack
  # This is the heart and soul of the Mack framework! This class interfaces with the Rack framework.
  # It handles all the dispatching back and forth between the Rack framework and a Mack application.
  class Runner
    include Extlib::Hook
    include Mack::Routes::Urls
    
    attr_reader :response # :nodoc:
    attr_reader :request # :nodoc:
    attr_reader :cookies # :nodoc:
    attr_reader :runner_helpers # :nodoc:
    attr_reader :original_controller
    attr_reader :original_action
    
    # This method needs to be defined as part of the Rack framework. As is noted for the Mack::Runner
    # class, this is where the center of the Mack framework lies.
    def call(env)
      begin
        setup(env)
        begin
          route = Mack::Routes.retrieve(self.request)
          if route[:redirect_to]
            # because the route is specified to be a redirect, let's do that:
            redirect_to(route)
          else
            # set these in case we need them for handling errors:
            @original_controller = route[:controller]
            @original_action = route[:action]
            run_controller(route)
          end
        # rescue Mack::Errors::ResourceNotFound, Mack::Errors::UndefinedRoute => e
        #   return try_to_find_resource(env, e)
        rescue Exception => e
          route = Mack::Routes.retrieve_from_error(e.class)
          self.request.all_params[:original_controller] = @original_controller
          self.request.all_params[:original_action] = @original_action
          unless route.nil?
            run_controller(route, e)
          else
            if e.class == Mack::Errors::ResourceNotFound || e.class == Mack::Errors::UndefinedRoute
              return try_to_find_resource(env, e)
            else
              raise e
            end
          end
        end
        teardown
      rescue Exception => e
        Mack.logger.error(e)
        raise e
      end
    end
    
    #private
    def run_controller(route, e = nil)
      runner_block = route[:runner_block]
      route - :runner_block
      
      self.request.params = self.request.all_params.merge(route)
      self.response.content_type = Mack::Utils::MimeTypes[self.request.params[:format]]
      catch(:finished) do
        if runner_block
          runner_block.call(self.request, self.response, self.cookies)
        end
      
        # let's handle a normal request:
        begin
          cont = "#{route[:controller].to_s.camelcase}Controller".constantize
        rescue NameError => e
          raise Mack::Errors::ResourceNotFound.new(self.request.path_info)
        end
      
        c = cont.new
        c.configure_controller(self.request, self.response, self.cookies)
        c.caught_exception = e unless e.nil?

        self.response.controller = c
        self.response.write(c.run)
      end
    end
    
    # Setup the request, response, cookies, session, etc...
    # yield up, and then clean things up afterwards.
    def setup(env)
      @request = Mack::Request.new(env) 
      @response = Mack::Response.new
      @cookies = Mack::CookieJar.new(self.request, self.response)
      @runner_helpers = []
      Mack::RunnerHelpers::Registry.registered_items.each do |helper|
        help = helper.new
        help.start(self.request, self.response, self.cookies)
        @runner_helpers << help
      end
    end
    
    def teardown
      self.runner_helpers.reverse.each do |help|
        help.complete(self.request, self.response, self.cookies)
      end
      self.response.finish
    end
    
    def try_to_find_resource(env, exception)
      env = env.dup
      # we can't find a route for this, so let's try and see if it's in the public directory:
      if File.extname(env["PATH_INFO"]).blank?
        env["PATH_INFO"] << ".html"
      end
      if File.exists?(Mack::Paths.public(env["PATH_INFO"]))
        return Rack::File.new(Mack::Paths.public).call(env)
      else
        raise exception
      end
    end
    
    # This will redirect the request to the specified url. A default status of
    # 302, Moved Temporarily, is set if no status is specified. A simple HTML
    # page is rendered in case the redirect does not occur.
    def redirect_to(route)
      status = route[:status] || 302
      url = route[:redirect_to]
      options = self.request.all_params
      options.merge!(route)
      options - [:controller, :action, :redirect_to, :method, :status, :format]
      url = url_for_pattern(url, options)
      self.response.status = status
      self.response[:location] = url
      self.response.write(redirect_html(self.request.path_info, url, status))
    end
    
  end
end
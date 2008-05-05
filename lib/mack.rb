require File.join(File.dirname(__FILE__), "initialization", "initializer")

module Mack
  # This is the heart and soul of the Mack framework! This class interfaces with the Rack framework.
  # It handles all the dispatching back and forth between the Rack framework and a Mack application.
  class Runner
    include Mack::Routes::Urls
    
    attr_reader :response # :nodoc:
    attr_reader :request # :nodoc:
    attr_reader :cookies # :nodoc:
    # This method needs to be defined as part of the Rack framework. As is noted for the Mack::Runner
    # class, this is where the center of the Mack framework lies.
    def call(env)
      # pp env
      begin
        setup(env) do
          begin
            route = Mack::Routes::RouteMap.instance.get_route_from_request(self.request)
            if route[:redirect_to]
              # because the route is specified to be a redirect, let's do that:
              redirect_to(route)
            else
              # let's handle a normal request:
              begin
                cont = "#{route[:controller].to_s.camelcase}Controller".constantize
              rescue NameError => e
                raise Mack::Errors::ResourceNotFound.new(self.request.path_info)
              end
              c = cont.new(self.request, self.response, self.cookies)
              self.response.controller = c
              self.response.write(c.run)
            end
          rescue Mack::Errors::ResourceNotFound, Mack::Errors::UndefinedRoute => e
            return try_to_find_resource(env, e)
          end
        end # setup
      rescue Exception => e
        MACK_DEFAULT_LOGGER.error(e)
        raise e
      end
    end
    
    private
    def log_request
      s_time = Time.now
      x = yield
      e_time = Time.now
      p_time = e_time - s_time
      if app_config.log.detailed_requests
        msg = "\n\t[#{@request.request_method.upcase}] '#{@request.path_info}'\n"
        msg << "\tSession ID: #{@request.session.id}\n"
        msg << "\tParameters: #{@request.all_params.inspect}\n"
        msg << "\tCompleted in #{p_time} (#{(1 / p_time).round} reqs/sec) | #{@response.status} [#{@request.full_host}]"
      else
        msg = "[#{@request.request_method.upcase}] '#{@request.path_info}' (#{p_time})"
      end
      MACK_DEFAULT_LOGGER.info(msg)
      x
    end
    
    # Setup the request, response, cookies, session, etc...
    # yield up, and then clean things up afterwards.
    def setup(env)
      exception = nil
      log_request do
        @request = Mack::Request.new(env) 
        @response = Mack::Response.new
        @cookies = Mack::CookieJar.new(self.request, self.response)
        session do
          begin
            yield
          rescue Exception => e
            exception = e
          end
        end
      end
      raise exception if exception
      self.response.finish
    end
    
    def session
      sess_id = self.cookies[app_config.mack.session_id]
      unless sess_id
        sess_id = create_new_session
      else
        sess = Cachetastic::Caches::MackSessionCache.get(sess_id)
        if sess
          self.request.session = sess
        else
          # we couldn't find it in the store, so we need to create it:
          sess_id = create_new_session
        end
      end

      yield
      
      Cachetastic::Caches::MackSessionCache.set(sess_id, self.request.session)
    end
    
    def create_new_session
      id = String.randomize(40).downcase
      self.cookies[app_config.mack.session_id] = {:value => id, :expires => nil}
      sess = Mack::Session.new(id)
      self.request.session = sess
      Cachetastic::Caches::MackSessionCache.set(id, sess)
      id
    end
    
    def try_to_find_resource(env, exception)
      env = env.dup
      # we can't find a route for this, so let's try and see if it's in the public directory:
      if File.extname(env["PATH_INFO"]).blank?
        env["PATH_INFO"] << ".html"
      end
      if File.exists?(File.join(Mack::Configuration.public_directory, env["PATH_INFO"]))
        return Rack::File.new(File.join(Mack::Configuration.public_directory)).call(env)
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
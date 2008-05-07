require 'erubis'
module Mack
  module Controller # :nodoc:
    # All controllers in a Mack application have to extend this class. I'll be honest, if they don't extend this class
    # then, well, things just won't work very well!
    # 
    # Example:
    #   class MyAwesomeController < Mack::Controller::Base
    #     def index
    #       render(:text => "Hello World!")
    #     end
    #   end
    class Base
      
      # See Mack::Request for more information.
      attr_reader :request
      # See Mack::Response for more information.
      attr_reader :response
      # The 'underscore' version of the controller requested. Example: 'my_awesome_controller'
      attr_reader :controller_name
      # The name of the action being requested.
      attr_reader :action_name
      # See Mack::CookieJar for more information.
      attr_reader :cookies

      def initialize(request, response, cookies)
        @request = request
        @response = response
        @render_options = {}
        @render_performed = false
        @controller_name = params(:controller)
        @action_name = params(:action)
        @cookies = cookies
        @wants_list = []
      end
      
      # Gives access to all the parameters for this request.
      def params(key)
        self.request.params(key)
      end
      
      # Gives access to the session. See Mack::Session for more information.
      def session
        self.request.session
      end
      
      # This does the heavy lifting for controllers. It calls the action, and then completes the rendering
      # of the action to a String to send back to Rack.
      def run
        run_filters(:before)
        # check to see if this controller responds to this action.
        # only run public methods!
        if self.public_methods.include?(self.action_name)
          # call the action and capture the results to a variable.
          @result_of_action_called = self.send(self.action_name)
        else
          # there is no action on this controller, so call the render method
          # which will check the view directory and run action.html.erb if it exists.
          render(:action => self.action_name)
        end
        run_filters(:after)
        # do the work of rendering.
        @final_rendered_action = complete_layout_render(complete_action_render)
        run_filters(:after_render)
        @final_rendered_action
      end
      
      # This method can be called from within an action. This 'registers' the render that you
      # would like to happen once the action is completed.
      # 
      # It's important to note that calling render in an action does NOT end the processing of
      # the action. The action will continue to process unless you explicity put 'return' before the
      # render call.
      # 
      # If you call render twice in an action then a Mack::Errors::DoubleRender error will be thrown.
      # 
      # An implicit render will happen if one is not specified in the action.
      # 
      # Only :action and :text will get layouts wrapped around them.
      #
      # You can also specify the response status code as part of the options hash.
      # 
      # Examples:
      #   class MyAwesomeController < Mack::Controller::Base
      #     # This will render the text 'Hello World!' to the screen.
      #     def index
      #       render(:text => "Hello World!")
      #     end
      # 
      #     # This will render Mack::Configuration.root/views/my_awesome_controller/foo.html.erb
      #     def show
      #       render(:action => :foo)
      #     end
      # 
      #     # This will raise a Mack::Errors::DoubleRender error.
      #     def edit
      #       render(:text => "Hello World!")
      #       render(:action => :foo)
      #     end
      # 
      #     # This will render Mack::Configuration.root/views/my_awesome_controller/delete.html.erb
      #     def delete
      #     end
      # 
      #     # This will render the text 'Hello World!' to the screen. Assuming that
      #     # there is no file: Mack::Configuration.root/views/my_awesome_controller/update.html.erb
      #     # The reason for this is if the view for the action doesn't exist, and the
      #     # last thing returned from the action is a String, that string will be returned.
      #     def update
      #       "Hello World!"
      #     end
      # 
      #     # This will raise a Mack::Errors::InvalidRenderType error. Assuming that
      #     # there is no file: Mack::Configuration.root/views/my_awesome_controller/create.html.erb
      #     def create
      #       @user = User.find(1)
      #     end
      # 
      #     # This will raise a Errno::ENOENT error. Assuming that
      #     # there is no file: Mack::Configuration.root/views/my_awesome_controller/bar.html.erb
      #     def bar
      #       render(:action => "bar")
      #     end
      #     
      #     # This will render a file from the public directory. Files served from the
      #     # public directory do NOT get layouts. The default file extension for files
      #     # served from the public directory is .html. This can be overridden with the
      #     # :ext => ".<ext>" option.
      #     def show_public_file
      #       render(:public => "my/files/foo")
      #     end
      # 
      #     # This will render a file from the public directory. Files served from the
      #     # public directory do NOT get layouts. The default file extension for files
      #     # served from the public directory is .html. This can be overridden with the
      #     # :ext => ".<ext>" option. 
      #     def show_public_xml_file
      #       render(:public => "my/files/foo", :ext => ".xml")
      #     end
      # 
      #     # This will render a partial. In this case it will look for:
      #     # Mack::Configuration.root/views/my_awesome_controller/_latest_news.html.erb
      #     # Partials do NOT get wrapped in layouts.
      #     def latest_news
      #       render(:partial => :latest_news)
      #     end
      # 
      #     # This will render a partial. In this case it will look for:
      #     # Mack::Configuration.root/views/some_other/_old_news.html.erb
      #     # Partials do NOT get wrapped in layouts.
      #     def latest_news
      #       render(:partial => "some_other/old_news")
      #     end
      # 
      #     # This will render a url. If the url does not return a status code of '200',
      #     # an empty string will be returned by default. The default method for rendering
      #     # urls is a get.
      #     def yahoo
      #       render(:url => "http://www.yahoo.com")
      #     end
      # 
      #     # This will render a url. If the url does not return a status code of '200',
      #     # a Mack::Errors::UnsuccessfulRenderUrl exception will be raised.
      #     def idontexist
      #       render(:url => "http://www.idontexist.com", :raise_exception => true)
      #     end
      # 
      #     # This will render a url with a post.
      #     def post_to_somewhere
      #       render(:url => "http://www.mackframework.com/post_to_me", :method => :post, 
      #              :parameters => {:id => 1, :user => "markbates"})
      #     end
      # 
      #     # This will render a 'local' url. If a domain is not present render url will
      #     # reach out for the config parameter "mack::site_domain" and prepend that
      #     # to the url. This can be overridden locally with the :domain option.
      #     def get_index
      #       render(:url => "/")
      #     end
      #
      #     # This will render 'application/404' and set the response status code to 404
      #     def to_the_unknown
      #       return render(:action => '/application/404', :status => 404)
      #     end
      #        
      #   end
      def render(options = {:action => self.action_name})
        raise Mack::Errors::DoubleRender.new if render_performed?
        response.status = options[:status] unless options[:status].nil?
        option = {:content_type => Mack::Utils::MimeTypes[params(:format)]}.merge(options)
        unless options[:action] || options[:text]
          options = {:layout => false}.merge(options)
        end
        response["Content-Type"] = option[:content_type]
        option.delete(:content_type)
        @render_options = options
        @render_performed = true
      end
      
      # This will redirect the request to the specified url. A default status of
      # 302, Moved Temporarily, is set if no status is specified. A simple HTML
      # page is rendered in case the redirect does not occur. A server side
      # redirect is also possible by using the option :server_side => true.
      # When a server side redirect occurs the url must be a 'local' url, not an
      # external url. The 'original' url of the request will NOT change.
      def redirect_to(url, options = {})
        options = {:status => 302}.merge(options)
        raise Rack::ForwardRequest.new(url) if options[:server_side]
        response.status = options[:status]
        response[:location] = url
        render(:text => redirect_html(request.path_info, url, options[:status]))
      end
      
      # In an action wants will run blocks of code based on the content type that has
      # been requested.
      # 
      # Examples:
      #   class MyAwesomeController < Mack::Controller::Base
      #     def hello
      #       wants(:html) do
      #         render(:text => "<html>Hello World</html>")
      #       end
      #       wants(:xml) do
      #         render(:text => "<xml><greeting>Hello World</greeting></xml>")
      #       end
      #     end
      #   end
      # 
      # If you were to go to: /my_awesome/hello you would get:
      #   "<html>Hello World</html>"
      # 
      # If you were to go to: /my_awesome/hello.html you would get:
      #   "<html>Hello World</html>"
      # 
      # If you were to go to: /my_awesome/hello.xml you would get:
      #   "<xml><greeting>Hello World</greeting></xml>"
      def wants(header_type, &block)
        header_type = header_type.to_sym
        if header_type == params(:format).to_sym
          yield
        end
      end
      
      # Returns true/false depending on whether the render action has been called yet.
      def render_performed?
        @render_performed
      end
      
      # Gives access to the MACK_DEFAULT_LOGGER.
      def logger
        MACK_DEFAULT_LOGGER
      end
      
      private
      
      def run_filters(type)
        filters = self.class.controller_filters[type]
        return true if filters.empty?
        filters.each do |filter|
          if filter.run?(self.action_name.to_sym)
            r = self.send(filter.filter_method)
            raise Mack::Errors::FilterChainHalted.new(filter.filter_method) unless r
          end
        end
      end
      
      def complete_layout_render(action_content)
        @content_for_layout = action_content
        # if @render_options[:action] || @render_options[:text]
          # only action and text should get a layout.
          # if a layout is specified, use that:
          # i use has_key? here because we want people
          # to be able to override layout with nil/false.
          if @render_options.has_key?(:layout)
            if @render_options[:layout]
              return Mack::ViewBinder.new(self).render(@render_options.merge({:action => "layouts/#{@render_options[:layout]}"}))
            else
              # someone has specified NO layout via nil/false
              return @content_for_layout
            end
          else layout
            # use the layout specified by the layout method
            begin
              return Mack::ViewBinder.new(self).render(@render_options.merge({:action => "layouts/#{layout}"}))
            rescue Errno::ENOENT => e
              # if the layout doesn't exist, we don't care.
            rescue Exception => e
              raise e
            end
          end
        # end
        @content_for_layout
      end

      def complete_action_render
        if render_performed?
          return Mack::ViewBinder.new(self, @render_options).render(@render_options)
        else
          begin
            # try action.html.erb
            return Mack::ViewBinder.new(self).render({:action => self.action_name})
          rescue Errno::ENOENT => e
            if @result_of_action_called.is_a?(String)
              @render_options[:text] = @result_of_action_called
              return Mack::ViewBinder.new(self).render(@render_options)
            else
              raise e
            end
          end
        end
      end # complete_action_render
      
      def layout
        :application
      end
      
      public
      class << self
        
        # See Mack::Controller::Filter for more information.
        def before_filter(meth, options = {})
          add_filter(:before, meth, options)
        end
        
        # See Mack::Controller::Filter for more information.
        def after_filter(meth, options = {})
          add_filter(:after, meth, options)
        end
        
        # See Mack::Controller::Filter for more information.
        def after_render_filter(meth, options = {})
          add_filter(:after_render, meth, options)
        end
        
        def add_filter(type, meth, options) # :nodoc:
          controller_filters[type.to_sym] << Mack::Controller::Filter.new(meth, self, options)
        end
        
        def controller_filters # :nodoc:
          unless @controller_filters
            @controller_filters = {:before => [], :after => [], :after_render => []}
            # inherit filters from the superclass, if any, to this parent
            sc = self.superclass
            if sc.class_is_a?(Mack::Controller::Base)
              ch = sc.controller_filters
              [:before, :after, :after_render].each do |v|
                @controller_filters[v] << ch[v]
                @controller_filters[v].flatten!
                @controller_filters[v].uniq!
              end
            end
          end
          @controller_filters
        end
        
        # Sets a layout to be used by a particular controller.
        # 
        # Example:
        #   class MyAwesomeController < Mack::Controller::Base
        #     # Sets all actions to use: "#{Mack::Configuration.root}/app/views/layouts/dark.html.erb" as they're layout.
        #     layout :dark
        # 
        #     def index
        #       # Sets this action to use: "#{Mack::Configuration.root}/app/views/layouts/bright.html.erb" as it's layout.
        #       render(:text => "Welcome...", :layout => :bright)
        #     end
        # 
        #     def index
        #       # This will no use a layout.
        #       render(:text => "Welcome...", :layout => false)
        #     end
        #   end
        # 
        # The default layout is "#{Mack::Configuration.root}/app/views/layouts/application.html.erb".
        # 
        # If a layout is specified, and it doesn't exist a Mack::Errors::UnknownLayout error will be raised.
        def layout(lay)
          self.class_eval do
            define_method(:layout) do
              lay
            end
          end
        end # layout
        
      end # class << self
      
    end # Base
  end # Controller
end # Mack
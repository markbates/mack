module Mack
  module Rendering # :nodoc:
    # This class is used to do all the view level bindings.
    # It allows for seperation between the Mack::Controller and the view levels.
    class ViewTemplate
      
      # Allows access to any options passed into the template.
      attr_accessor :options
      attr_accessor :render_type
      attr_accessor :render_value
      
      def initialize(render_type, render_value, options = {})
        self.render_type = render_type
        self.render_value = render_value
        self.options = options
        @_yield_to_cache = {}
        Thread.current[:view_template] = self
      end
      
      # Allows access to the current Mack::Controller object.
      def controller
        self.options[:controller]
      end
      
      # Returns the Mack::Request associated with the current Mack::Controller object.
      def request
        self.controller.request
      end
      
      # Returns the Mack::Session associated with the current Mack::Request.
      def session
        self.request.session
      end
      
      # Returns the Mack::CookieJar associated with the current Mack::Controller object.
      def cookies
        self.controller.cookies
      end
      
      # If a method can not be found then the :locals key of
      # the options is used to find the variable.
      def method_missing(sym, *args)
        raise NoMethodError.new(sym.to_s) unless self.options[:locals]
        self.options[:locals][sym]
      end
      
      # Maps to the controller's param method. See also Mack::Controller::Base params.
      def params
        self.controller.params
      end
      
      # Handles rendering calls both in the controller and in the view.
      # For full details of render examples see Mack::Controller render.
      # Although the examples there are all in controllers, they idea is still
      # the same for views.
      # 
      # Examples in the view:
      #   <%= render(:text,  "Hello") %>
      #   <%= render(:action, "show") %>
      #   <%= render(:partial, :latest_news) %>
      #   <%= render(:url, "http://www.mackframework.com") %>
      def render(render_type, render_value, options = {})
        options = self.options.merge({:layout => false}).merge(options)
        Mack::Rendering::ViewTemplate.new(render_type, render_value, options).compile_and_render
      end
      
      # Returns a string stored using content_for.
      # 
      # Example:
      #   <% content_for(:hello, "Hello World") %>
      #   <%= yield_to :hello %> # => "Hello World"
      #   
      #   <% content_for(:bye) do %>
      #     Ah, it's so sad to say goodbye.
      #   <% end %>
      #   <%= yield_to :bye %> # => "Ah, it's so sad to say goodbye."
      def yield_to(key)
        @_yield_to_cache[key.to_sym]
      end
      
      # Stores a string that can be retrieved using yield_to.
      # 
      # Example:
      #   <% content_for(:hello, "Hello World") %>
      #   <%= yield_to :hello %> # => "Hello World"
      #   
      #   <% content_for(:bye) do %>
      #     Ah, it's so sad to say goodbye.
      #   <% end %>
      #   <%= yield_to :bye %> # => "Ah, it's so sad to say goodbye."
      def content_for(key, value = nil, &block)
        return @_yield_to_cache[key.to_sym] = value unless value.nil?
        return @_yield_to_cache[key.to_sym] = @_render_type.capture(&block) if block_given?
      end

      # Transfers all the instance variables from the controller to the current instance of
      # the view template. This call is cached, so it only happens once, regardless of the number
      # of times it is called.
      def compile
        ivar_cache("compiled_template") do
          self.options.symbolize_keys!
          transfer_vars(self.controller)
        end
      end
      
      # Fully compiles and renders the view and, if applicable, it's layout.
      def compile_and_render
        self.compile
        content_for(:view, render_view)
        render_layout
      end
      
      # Passes concatenation messages through to the Mack::Rendering::Type object.
      # This should append the text, using the passed in binding, to the final output
      # of the render.
      def concat(txt, b)
        @_render_type.concat(txt, b)
      end
      
      # Primarily used by Mack::Rendering::Type::Url when dealing with 'local' urls.
      # This returns an instance of the current application to run additional requests
      # through.
      def app_for_rendering
        ivar_cache do
          Mack::Utils::Server.build_app
        end
      end
      
      # Returns the binding of the current view template to be used with
      # the engines to render.
      def binder
        binding
      end
      
      private
      
      def render_layout
        if @_render_type.allow_layout? && self.options[:layout]
          return Mack::Rendering::Type::Layout.new(self).render
        end
        return yield_to(:view)
      end
      
      def render_view
        @_render_type = find_render_type(self.render_type).new(self)
        @_render_type.render
      end
      
      def find_file(*path)
        f = File.join(path)
        if File.exists?(f)
          yield f
        end
      end
  
      # Transfer instance variables from the controller to the view.
      def transfer_vars(x)
        x.instance_variables.each do |v|
          self.instance_variable_set(v, x.instance_variable_get(v))
        end
      end
      
      def find_render_type(e)
        eval("Mack::Rendering::Type::#{e.to_s.camelcase}")
      end
      
    end # ViewTemplate
  end # Mack
end # Mack
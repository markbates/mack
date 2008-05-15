module Mack
  module Rendering
    # This class is used to do all the view level bindings.
    # It allows for seperation between the controller and the view levels.
    class ViewTemplate
      
      # Allows access to any options passed into the template.
      attr_accessor :options
      attr_accessor :engine_type
      attr_accessor :engine_type_value
      
      def initialize(engine_type, engine_type_value, options = {})
        self.engine_type = engine_type
        self.engine_type_value = engine_type_value
        self.options = options
        @yield_to_cache = {}
      end
      
      def add_options(opts)
        self.options.merge!(opts)
      end
      
      # Allows access to the controller.
      def controller
        self.options[:controller]
      end
      
      def request
        self.controller.request
      end
      
      def session
        self.request.session
      end
      
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
      def params(key)
        self.controller.params(key)
      end
      
      # Handles rendering calls both in the controller and in the view.
      # For full details of render examples see Mack::Controller::Base render.
      # Although the examples there are all in controllers, they idea is still
      # the same for views.
      # 
      # Examples in the view:
      #   <%= render(:text => "Hello") %>
      #   <%= render(:action => "show") %>
      #   <%= render(:partial => :latest_news) %>
      #   <%= render(:url => "http://www.mackframework.com") %>
      def render(engine_type, engine_type_value, options = {})
        options = self.options.merge({:layout => false}).merge(options)
        Mack::Rendering::ViewTemplate.new(engine_type, engine_type_value, options).compile_and_render
      end
      
      def xml
        @xml
      end
      
      def yield_to(key)
        @yield_to_cache[key.to_sym]
      end
      
      def content_for(key, value = nil)
        @yield_to_cache[key.to_sym] = value unless value.nil?
        @yield_to_cache[key.to_sym] = yield if block_given?
      end

      def controller_view_path
        ivar_cache do
          File.join(Mack::Configuration.views_directory, self.controller.controller_name)
        end
      end
      
      def compile
        ivar_cache("compiled_template") do
          self.options.symbolize_keys!
          transfer_vars(self.controller)
        end
      end
      
      def compile_and_render
        self.compile
        content_for(:view) do
          render_view
        end
        render_layout
      end
      
      def concat(txt, b)
        @render_type.concat(txt, b)
      end
      
      def app_for_rendering
        ivar_cache do
          Mack::Utils::Server.build_app
        end
      end
      
      def binder
        binding
      end
      
      private
      
      def render_layout
        if @render_type.allow_layout? && self.options[:layout]
          return Mack::Rendering::Type::Layout.new(self).render
        end
        return yield_to(:view)
      end
      
      def render_view
        @render_type = render_type(self.engine_type).new(self)
        @render_type.render
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
      
      def render_type(e)
        eval("Mack::Rendering::Type::#{e.to_s.camelcase}")
      end
      
    end # ViewTemplate
  end # Mack
end # Mack
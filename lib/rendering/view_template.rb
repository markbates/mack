module Mack
  module Rendering
    # This class is used to do all the view level bindings.
    # It allows for seperation between the controller and the view levels.
    class ViewTemplate
      
      # Allows access to any options passed into the template.
      attr_accessor :options
      
      def initialize(options = {})
        self.options = {:engine => :erb}.merge(options)
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
      def render(options)
        options = {:controller => self.controller, :layout => false}.merge(options)
        Mack::Rendering::ViewTemplate.new(options).compile_and_render
      end
      
      def xml
        @xml_builder.xml
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
        eval( "_buf", b) << txt
      end
      
      def app_for_rendering
        ivar_cache do
          Mack::Utils::Server.build_app
        end
      end
      
      private
      
      def render_layout
        if self.options[:layout]
          Mack::Rendering::Layout::ENGINES.each do |e|
            find_file(Mack::Configuration.views_directory, "layouts", "#{self.options[:layout]}.#{self.options[:format]}.#{e}") do |f|
              return engine(e).render(File.open(f).read, binding)
            end
          end
        end
        return yield_to(:view)
      end
      
      def render_view
        if self.options[:action]
          Mack::Rendering::Action::ENGINES.each do |e|
            find_file(controller_view_path, "#{self.options[:action]}.#{self.options[:format]}.#{e}") do |f|
              return engine(e).render(File.open(f).read, binding)
            end
          end
        elsif self.options[:text]
          return engine(options[:engine]).render(self.options[:text], binding)
        elsif self.options[:partial]
          self.options[:layout] = false
          partial = self.options[:partial].to_s
          parts = partial.split("/")
          if parts.size == 1
            # it's local to this controller
            partial = "_" << partial
            partial = File.join(controller_view_path, partial)
            # partial = File.join(options[:dir], self.view_binder.controller.controller_name, partial + options[:ext])
          else
            # it's elsewhere
            parts[parts.size - 1] = "_" << parts.last
            partial = File.join(Mack::Configuration.views_directory, parts)
          end
          
          Mack::Rendering::Action::ENGINES.each do |e|
            find_file(partial + ".#{self.options[:format]}.#{e}") do |f|
              return engine(e).render(File.open(f).read, binding)
            end
          end
        elsif self.options[:public]
          self.options[:layout] = false
          p_file = "#{self.options[:public]}.#{self.options[:format]}"
          find_file(Mack::Configuration.public_directory, p_file) do |f|
            return File.open(f).read
          end
          raise Mack::Errors::ResourceNotFound.new(p_file)
        elsif self.options[:url]
          self.options[:layout] = false
          e = Mack::Rendering::Engines::Url.new(self, self.options)
          return e.render
        elsif self.options[:xml]
          Mack::Rendering::Xml::ENGINES.each do |e|
            find_file(controller_view_path, "#{self.options[:xml]}.#{self.options[:format]}.#{e}") do |f|
              @xml_builder = engine(e).new
              return @xml_builder.render(File.open(f).read, binding)
            end
          end
        else
          raise Mack::Errors::UnknownRenderOption.new(options.inspect)
        end
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
      
      def engine(e)
        eval("Mack::Rendering::Engines::#{e.to_s.camelcase}")
      end
      
    end # ViewTemplate
  end # Mack
end # Mack
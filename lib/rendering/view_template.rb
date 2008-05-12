module Mack
  module Rendering
    class ViewTemplate
      
      attr_accessor :options
      
      def initialize(options = {})
        self.options = {:engine => :erb}.merge(options)
        @yield_to_cache = {}
      end
      
      def add_options(opts)
        self.options.merge!(opts)
      end
      
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
        if self.options[:action]
          Mack::Rendering::Action::ENGINES.each do |e|
            f = File.join(controller_view_path, "#{self.options[:action]}.#{self.options[:format]}.#{e}")
            if File.exists?(f)
              content_for(:view, engine(e).render(File.open(f).read, binding))
            end
          end
        elsif self.options[:text]
          content_for(:view, engine(options[:engine]).render(self.options[:text], binding))
        elsif self.options[:partial]
          self.options[:layout] = false
        elsif self.options[:public]
          self.options[:layout] = false
        elsif self.options[:url]
          self.options[:layout] = false
          e = Mack::Rendering::Engines::Url.new(self, self.options)
          content_for(:view, e.render)
        elsif self.options[:xml]
          Mack::Rendering::Xml::ENGINES.each do |e|
            f = File.join(controller_view_path, "#{self.options[:xml]}.#{self.options[:format]}.#{e}")
            if File.exists?(f)
              @xml_builder = engine(e).new
              content_for(:view, @xml_builder.render(File.open(f).read, binding))
            end
          end
        else
          raise Mack::Errors::UnknownRenderOption.new(options.inspect)
        end
        if self.options[:layout]
          Mack::Rendering::Layout::ENGINES.each do |e|
            f = File.join(Mack::Configuration.views_directory, "layouts", "#{self.options[:layout]}.#{self.options[:format]}.#{e}")
            if File.exists?(f)
              return engine(e).render(File.open(f).read, binding)
            end
          end
        end
        return yield_to :view
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

if __FILE__ == $0
  def complete_action_render
    if render_performed?
      return Mack::Rendering::ViewBinder.new(self, @render_options).render(@render_options)
    else
      begin
        # try action.html.erb
        return Mack::Rendering::ViewBinder.new(self).render({:action => self.action_name})
      rescue Errno::ENOENT => e
        if @result_of_action_called.is_a?(String)
          @render_options[:text] = @result_of_action_called
          return Mack::Rendering::ViewBinder.new(self).render(@render_options)
        else
          raise e
        end
      end
    end
  end # complete_action_render      
  
  def complete_layout_render(action_content)
    @content_for_layout = action_content
    # if @render_options[:action] || @render_options[:text]
      # only action and text should get a layout.
      # if a layout is specified, use that:
      # i use has_key? here because we want people
      # to be able to override layout with nil/false.
      if @render_options.has_key?(:layout)
        if @render_options[:layout]
          return Mack::Rendering::ViewBinder.new(self).render(@render_options.merge({:action => "layouts/#{@render_options[:layout]}"}))
        else
          # someone has specified NO layout via nil/false
          return @content_for_layout
        end
      else layout
        # use the layout specified by the layout method
        begin
          return Mack::Rendering::ViewBinder.new(self).render(@render_options.merge({:action => "layouts/#{layout}"}))
        rescue Errno::ENOENT => e
          # if the layout doesn't exist, we don't care.
        rescue Exception => e
          raise e
        end
      end
    # end
    @content_for_layout
  end
end
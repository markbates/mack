module Mack
  module Rendering
    class ViewTemplate
      
      attr_accessor :options
      attr_accessor :view_binder
      
      def initialize(options = {})
        self.view_binder = Mack::Rendering::ViewBinder.new
        self.options = {:engine => "erb"}.merge(options)
      end
      
      def add_options(opts)
        self.options.merge!(opts)
      end
      
      def method_missing(sym, *args)
        self.options[sym]
      end
      
      def compile
        engine = eval("Mack::Rendering::Engines::#{self.engine.camelcase}").render(self, binding)
        # engine.render(File.open(File.join(self.options[:file_path], "app", "views", self.options[:controller], self.options[:action] + ".#{self.format}.#{self.engine}")).read, binding)
      end
      
      def compile_and_render
        
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
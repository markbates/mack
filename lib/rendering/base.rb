module Mack
  module Rendering
    # This is the base class from which all rendering systems need to extend.
    class Base
      
      attr_accessor :view_binder # The Mack::ViewBinder that called this rendering system.
      attr_accessor :options # The options associated with this render call
      
      def initialize(view_binder, options)
        self.view_binder = view_binder
        self.options = options
      end
      
      # This is the only method that needs to be implemented by a rendering system.
      # It should return a String.
      def render
        raise MethodNotImplemented.new("render")
      end
      
      private
      # Used to render a file from disk.
      def render_file(f, options = {})
        options = {:is_partial => false, :ext => ".html.erb", :dir => MACK_VIEWS}.merge(options)
        partial = f.to_s
        parts = partial.split("/")
        if parts.size == 1
          # it's local to this controller
          partial = "_" << partial if options[:is_partial]
          partial = File.join(options[:dir], self.view_binder.controller.controller_name, partial + options[:ext])
        else
          # it's elsewhere
          parts[parts.size - 1] = "_" << parts.last if options[:is_partial]
          partial = File.join(options[:dir], parts.join("/") + options[:ext])
        end
        return Mack::ViewBinder.render(File.open(partial).read, self.view_binder.controller, options)
      end
      
    end # Base
  end # Rendering
end # Mack
module Mack
  module Rendering
    # This is the base class from which all rendering systems need to extend.
    # 
    # Example:
    #   class Mack::Rendering::Pdf < Mack::Rendering::Base
    #     def render
    #       # do work to render stuff as a PDF
    #     end
    #   end
    # 
    # Now add this to the list of available render systems:
    #   app_config.mack.rendering_systems << :pdf
    # 
    # You should now be able to do this in your controller:
    # 
    #   class MyAwesomeController < Mack::Controller::Base
    #     def pdf
    #       render(:pdf => "my_pdf_template")
    #     end
    #   end
    class Base
      
      attr_accessor :view_binder # The Mack::ViewBinder that called this rendering system.
      attr_accessor :options # The options associated with this render call
      
      def initialize(view_binder, options)
        self.view_binder = view_binder
        self.options = {:parameters => {}}.merge(options)
      end
      
      # This is the only method that needs to be implemented by a rendering system.
      # It should return a String.
      needs_method :render
      
      # Maps to the view_binder's param method. See also Mack::ViewBinder params.
      def params(key)
        self.view_binder.params(key)
      end
      
      private
      # Used to render a file from disk.
      def render_file(f, options = {})
        options = {:is_partial => false, :ext => ".#{self.params(:format)}.erb", :dir => MACK_VIEWS}.merge(options)
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
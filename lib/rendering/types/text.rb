module Mack
  module Rendering
    # Used when someone calls render(:text => "Hello World!")
    class Text < Base
      
      def render
        Mack::Rendering::ViewBinder.render(options[:text], self.view_binder.controller, options)
      end
      
    end
  end
end
module Mack
  module Rendering
    # Used when someone calls render(:xml => "rss_feed")
    class Xml < Base
      
      def render
        # Mack::ViewBinder.render(options[:text], self.view_binder.controller, options)
      end
      
    end
  end
end
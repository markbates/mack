module Mack
  module Rendering
    # Used when someone calls render(:text => "Hello World!")
    class Text < Base
      
      ENGINES = [:erb, :markaby, :haml]
      
      def render
        Mack::Rendering::ViewTemplate.render(options[:text], self.view_binder.controller, options)
      end
      
    end
  end
end
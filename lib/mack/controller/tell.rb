module Mack
  module Controller
    module Tell
      
      def tell
        (session[:tell] ||= {})
      end
      
      include_safely_into(Mack::Controller, Mack::Rendering::ViewTemplate)
      
    end # Tell
  end # Controller
end # Mack
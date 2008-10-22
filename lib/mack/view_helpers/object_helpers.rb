module Mack
  module ViewHelpers # :nodoc:
    module ObjectHelpers
      
      # Useful for debugging objects in views. Just pass it an object
      # and will grap the pretty print of the inspect and wrap it in 
      # HTML pre tags.
      def debug(obj)
        "<pre>#{pp_to_s(obj).gsub('<', '&lt;')}</pre>"
      end
      
    end # ObjectHelpers
  end # ViewHelpers
end # Mack
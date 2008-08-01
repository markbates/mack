module Mack
  module ViewHelpers # :nodoc:
    # Used to easily include all Mack::ViewHelpers. It will NOT include itself!
    # This is primarily used to aid in testing view helpers.
    module AllHelpers
    
      def self.included(base)
        unless base.is_a?(Mack::ViewHelpers::AllHelpers)
          base.class_eval do
            Mack::ViewHelpers.constants.each do |c|
              include "Mack::ViewHelpers::#{c}".constantize unless c == "AllHelpers"
            end
          end # class_eval
        end # unless
      end # included
    
    end # All
  end # ViewHelpers
end # Mack
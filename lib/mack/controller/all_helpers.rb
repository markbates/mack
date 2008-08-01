module Mack
  module ControllerHelpers # :nodoc:
    # Used to easily include all Mack::ControllerHelpers. It will NOT include itself!
    # This is primarily used to aid in testing controller helpers.
    module AllHelpers
    
      def self.included(base)
        unless base.is_a?(Mack::ControllerHelpers::AllHelpers)
          base.class_eval do
            Mack::ViewHelpers.constants.each do |c|
              include "Mack::ControllerHelpers::#{c}".constantize unless c == "AllHelpers"
            end
          end # class_eval
        end # unless
      end # included
    
    end # All
  end # ViewHelpers
end # Mack
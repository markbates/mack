module Mack
  module ViewHelpers # :nodoc:
    # Used to easily include all Mack::ViewHelpers. It will NOT include itself!
    # This is primarily used to aid in testing view helpers.
    def self.included(base)
      base.class_eval do
        Mack::ViewHelpers.constants.each do |c|
          mod = "Mack::ViewHelpers::#{c}".constantize
          include mod unless base.is_a?(mod)
        end
      end # class_eval
    end # included
    
  end # ViewHelpers
end # Mack
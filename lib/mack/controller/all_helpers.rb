module Mack
  module ControllerHelpers # :nodoc:

    # Used to easily include all Mack::ControllerHelpers. It will NOT include itself!
    # This is primarily used to aid in testing controller helpers.
    def self.included(base)
      Mack::ControllerHelpers.constants.each do |c|
        mod = "Mack::ControllerHelpers::#{c}".constantize
        mod.include_safely_into(base) unless base.is_a?(mod)
      end
    end # included
    
  end # ViewHelpers
end # Mack
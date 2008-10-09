require 'mack-facets'

run_once do

  require File.join_from_here('app')
  
  init_message('helpers')

  module Mack
    module ControllerHelpers # :nodoc:
    end
  
    module ViewHelpers # :nodoc:
    end
  end

  # Find controller level Helpers and include them into their respective controllers
  Mack::ControllerHelpers.constants.each do |cont|
    h = "Mack::ControllerHelpers::#{cont}"
    if Object.const_defined?(cont)
      h.constantize.include_safely_into(cont.constantize)
    else
      Mack.logger.warn("Could not find: #{cont} controller for helper: #{h}")
    end
  end

  # Find view level Helpers and include them into the Mack::Rendering::ViewTemplate
  Mack::ViewHelpers.constants.each do |cont|
    h = "Mack::ViewHelpers::#{cont}".constantize
    Mack::Rendering::ViewTemplate.send(:include, h)
  end
  
end
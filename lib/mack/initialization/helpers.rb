boot_load(:helpers, :logging) do
  # Include ApplicationHelper into all controllers:
  Mack.logger.debug "Initializing helpers..." unless app_config.log.disable_initialization_logging
  # adding application_helper module into all defined controllers
  if Object.const_defined?("ApplicationHelper")
    deprecate_method("ApplicationHelper", "Mack::ViewHelpers::ApplicationHelper", "0.7.0")
    ApplicationHelper.include_safely_into(Mack::Rendering::ViewTemplate)
  end

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
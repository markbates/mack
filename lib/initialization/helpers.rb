# Include ApplicationHelper into all controllers:
Mack.logger.info "Initializing helpers..."
# adding application_helper module into all defined controllers
if Object.const_defined?("ApplicationHelper")
  Mack.logger.warn("ApplicationHelper has been deprecated! Please use move it to Mack::ViewHelpers::ApplicationHelper instead.")
  ApplicationHelper.include_safely_into(Mack::Rendering::ViewTemplate)
end

module Mack
  module ControllerHelpers
  end
  
  module ViewHelpers
  end
end

# Find controller level Helpers and include them into their respective controllers
Mack::ControllerHelpers.constants.each do |cont|
  h = "Mack::ControllerHelpers::#{cont}"
  c_name = h.match(/Mack::ControllerHelpers::(.+)Helper/)[1]
  if Object.const_defined?(c_name)
    h.constantize.include_safely_into(c_name.constantize)
  else
    Mack.logger.warn("Could not find: #{c_name} controller for helper: #{h}")
  end
end

# Find view level Helpers and include them into the Mack::Rendering::ViewTemplate
Mack::ViewHelpers.constants.each do |cont|
  h = "Mack::ViewHelpers::#{cont}".constantize
  h.include_safely_into(Mack::Rendering::ViewTemplate)
end
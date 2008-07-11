# Include ApplicationHelper into all controllers:
Mack.logger.info "Initializing helpers..."
# adding application_helper module into all defined controllers
if Object.const_defined?("ApplicationHelper")
  Mack.logger.warn("ApplicationHelper has been deprecated! Please use Mack::ViewHelpers, Mack::ControllerHelpers, or Mack::ViewContHelpers modules instead.")
  Object.constants.collect {|c| c if c.match(/Controller$/)}.compact.each do |cont|
    ApplicationHelper.include_safely_into(cont, Mack::Rendering::ViewTemplate)
  end
end

# Find other Helpers and include them into their respective controllers.
# Object.constants.collect {|c| c if c.match(/Controller$/)}.compact.each do |cont|
#   if Object.const_defined?("#{cont}Helper")
#     h = "#{cont}Helper".constantize
#     h.include_safely_into(cont, Mack::Rendering::ViewTemplate)
#   end
# end

module Mack
  module ControllerHelpers
  end
  
  module ViewHelpers
  end
  
  module ViewContHelpers
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

# Find controller level Helpers and include them into their respective controllers
Mack::ViewContHelpers.constants.each do |cont|
  h = "Mack::ViewContHelpers::#{cont}"
  c_name = h.match(/Mack::ViewContHelpers::(.+)Helper/)[1]
  h.constantize.include_safely_into(Mack::Rendering::ViewTemplate)
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
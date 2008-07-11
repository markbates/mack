# Include ApplicationHelper into all controllers:
Mack.logger.info "Initializing helpers..."
# adding application_helper module into all defined controllers
Object.constants.collect {|c| c if c.match(/Controller$/)}.compact.each do |cont|
  ApplicationHelper.include_safely_into(cont, Mack::Rendering::ViewTemplate)
end

# Find other Helpers and include them into their respective controllers.
Object.constants.collect {|c| c if c.match(/Controller$/)}.compact.each do |cont|
  if Object.const_defined?("#{cont}Helper")
    h = "#{cont}Helper".constantize
    h.include_safely_into(cont, Mack::Rendering::ViewTemplate)
  end
end

# Find view level Helpers and include them into the Mack::Rendering::ViewTemplate
Mack::ViewHelpers.constants.each do |cont|
  h = "Mack::ViewHelpers::#{cont}".constantize
  h.include_safely_into(Mack::Rendering::ViewTemplate)
end
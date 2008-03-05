class Object
  
  # This method gets called when a parameter is passed into a named route.
  # This can be overridden in an Object to provlde custom handling of parameters.
  def to_param
    self.to_s
  end
  
end
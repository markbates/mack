module SomeRandomHelper
  
  def say_random
    String.random
  end
  
  self.include_safely_into(Mack::Controller)
end
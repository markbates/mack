class Module
  
  # Bulk converts the security level of methods in this Module from one level to another.
  def convert_security_of_methods(old_level = :public, new_level = :protected)
    eval("#{old_level}_instance_methods").each{ |meth| self.send(new_level, meth) }
    self
  end
  
  # Includes this module into an Object, and changes all public methods to protected.
  # 
  # Examples:
  #   module MyCoolUtils
  #     def some_meth
  #       "hi"
  #     end
  #     self.include_safely_into(FooController)
  #   end
  # or:
  #   MyCoolUtils.include_safely_into(FooController, SomeOtherClass)
  def include_safely_into(*args)
    [args].flatten.each do |a|
      if a.is_a?(String) || a.is_a?(Symbol)
        a = a.to_s.constantize
      end
      a.send(:include, self.convert_security_of_methods)
    end
  end
  
end
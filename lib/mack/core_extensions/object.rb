class Object
  
  def errors_for(meth_name)
    if self.respond_to?("errors") and self.errors
      return self.errors[meth_name.to_sym]
    end
    return nil
  end
  
  def has_errors?(meth_name)
    res = errors_for(meth_name)
    return !res.empty? if res.is_a?(Array)
    return !res.blank?
  end
  
end
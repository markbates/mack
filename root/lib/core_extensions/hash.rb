class Hash
  
  # Deletes the key(s) passed in from the hash.
  def -(ars)
    [ars].flatten.each {|a| self.delete(a)}
    self
  end
  
  # Converts a hash to query string parameters. 
  # An optional boolean escapes the values if true, which is the default.
  def to_params(escape = true)
    params = ''
    stack = []
    
    each do |k, v|
      if v.is_a?(Hash)
        stack << [k,v]
      else
        v = Rack::Utils.escape(v) if escape
        params << "#{k}=#{v}&"
      end
    end
    
    stack.each do |parent, hash|
      hash.each do |k, v|
        if v.is_a?(Hash)
          stack << ["#{parent}[#{k}]", v]
        else
          v = Rack::Utils.escape(v) if escape
          params << "#{parent}[#{k}]=#{v}&"
        end
      end
    end
    
    params.chop! # trailing &
    params
  end
  
end
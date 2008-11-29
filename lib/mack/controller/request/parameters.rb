module Mack
  class Request
    
    private
    class Parameters < Hash # :nodoc:
      
      alias_instance_method :[], :old_hash
      alias_instance_method :store
      
      def [](key)
        key = key.to_s.downcase
        data = old_hash(key.to_sym) || old_hash(key)
        data = data.to_s if data.is_a?(Symbol)
        return data
      end
      
      def []=(key, value)
        _original_store(key.downcase.to_sym, value)
      end
      
      def to_s
        s = self.inspect
        Mack::Logging::Filter.list.each do |p|
          s.gsub!(/:#{p}=>\"[^\"]+\"/, ":#{p}=>\"<FILTERED>\"")
        end
        s
      end
      
    end # Parameters
  end # Request
end # Mack
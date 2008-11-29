module Mack
  class Request
    
    private
    class DateTimeParameter # :nodoc:
      attr_accessor :year
      attr_accessor :month
      attr_accessor :day
      attr_accessor :hour
      attr_accessor :minute
      attr_accessor :second
      
      def initialize
        self.year = Time.now.year
        self.month = 1
        self.day = 1
        self.hour = 0
        self.minute = 0
        self.second = 0
      end
      
      def add(key, value)
        self.send("#{key}=", value)
      end
      
      def to_s
        "#{year}-#{month}-#{day} #{hour}:#{minute}:#{second}"
      end
      
      def to_time
        Time.parse(self.to_s)
      end
      
    end
    
  end # Request
end # Mack
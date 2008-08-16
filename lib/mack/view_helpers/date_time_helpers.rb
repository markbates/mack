module Mack
  module ViewHelpers # :nodoc:
    module FormHelpers
      
      MONTHS = [["January", 1], ["February", 2], ["March", 3], ["April", 4], ["May", 5], ["June", 6], ["July", 7], ["August", 8], 
                ["September", 9], ["October", 10], ["November", 11], ["December", 12]]
      DAYS = []
      1.upto(31) do |m| 
        DAYS << [(m < 10 ? "0#{m}" : m), m]
      end
      HOURS = []
      1.upto(24) do |h|
        HOURS << [(h < 10 ? "0#{h}" : h), h]
      end
      MINUTES = []
      1.upto(59) do |m| 
        MINUTES << [(m < 10 ? "0#{m}" : m), m]
      end
      
      def date_time_select(name, *args)
        var = instance_variable_get("@#{name}")
        fe = FormElement.new(*args)
        
        label = label_parameter_tag(name, (fe.calling_method == :to_s ? name : "#{name}_#{fe.calling_method}"), var, fe)
        
        time = var.nil? ? Time.now : (var.send(fe.calling_method) || Time.now)
        # years = ((time.year - 5)..(time.year + 5)).to_a
        years = []
        (time.year - 5).upto(time.year + 5) { |y| years << [y, y]}
        
        boxes = "#{dt_select(:month, name, fe, time.month, MONTHS)}/#{dt_select(:day, name, fe, time.day, DAYS)}/#{dt_select(:year, name, fe, time.year, years)} #{dt_select(:hour, name, fe, time.hour, HOURS)}:#{dt_select(:minute, name, fe, time.min, MINUTES)}"
        
        return label + boxes
      end
      
      private
      def dt_select(col, name, fe, selected, values)
        options = {:name => name, :id => name}
        unless fe.calling_method == :to_s
          options.merge!(:name => "#{name}[#{fe.calling_method}(#{col})]", :id => "#{name}_#{fe.calling_method}_#{col}")
        end
        options.merge!(:options => values, :selected => selected)
        select_tag(name, fe.options.merge(options))
      end
      
    end # DateTimeHelpers
  end # ViewHelpers
end # Mack
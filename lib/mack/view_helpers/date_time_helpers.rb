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
        
        time = var.nil? ? Time.now : (var.send(fe.calling_method) || Time.now)
        
        years = []
        (time.year - 5).upto(time.year + 5) { |y| years << [y, y]}
        
        options = {:years => true, :months => true, :days => true, :hours => true, :minutes => true, :seconds => false, :year_options => years, :month_options => MONTHS, :day_options => DAYS, :hour_options => HOURS, :minute_options => MINUTES, :second_options => MINUTES}.merge(fe.options)
        
        [:year, :month, :day, :hour, :minute, :second].each do |v|
          if options["#{v}_values".to_sym]
            options["#{v}_options".to_sym] = []
            options["#{v}_values".to_sym].each {|i| options["#{v}_options".to_sym] << [i, i]}
          end
        end
        
        fe.options - [:years, :months, :days, :hours, :minutes, :seconds, :year_options, :month_options, :day_options, :hour_options, :minute_options, :second_options, :year_values, :month_values, :day_values, :hour_values, :minute_values, :second_values]
        
        label = label_parameter_tag(name, (fe.calling_method == :to_s ? name : "#{name}_#{fe.calling_method}"), var, fe)

        
        date_boxes = []
        date_boxes << dt_select(:month, name, fe, time.month, options[:month_options]) if options[:months]
        date_boxes << dt_select(:day, name, fe, time.day, options[:day_options]) if options[:days]
        date_boxes << dt_select(:year, name, fe, time.year, options[:year_options]) if options[:years]
        
        time_boxes = []
        time_boxes << dt_select(:hour, name, fe, time.hour, options[:hour_options]) if options[:hours]
        time_boxes << dt_select(:minute, name, fe, time.min, options[:minute_options]) if options[:minutes]
        time_boxes << dt_select(:second, name, fe, time.sec, options[:second_options]) if options[:seconds]
        
        boxes = date_boxes.join("/")
        
        unless time_boxes.empty?
          boxes << " " << time_boxes.join(":")
        end
        
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
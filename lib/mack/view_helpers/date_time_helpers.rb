module Mack
  module ViewHelpers # :nodoc:
    module FormHelpers
      
      MONTHS = [["January", 1], ["February", 2], ["March", 3], ["April", 4], ["May", 5], ["June", 6], ["July", 7], ["August", 8], 
                ["September", 9], ["October", 10], ["November", 11], ["December", 12]] unless defined?(MONTHS)
      unless defined?(DAYS)
        DAYS = []
        1.upto(31) do |m| 
          DAYS << [(m < 10 ? "0#{m}" : m), m]
        end
      end
      unless defined?(HOURS)
        HOURS = []
        1.upto(24) do |h|
          HOURS << [(h < 10 ? "0#{h}" : h), h]
        end
      end
      unless defined?(MINUTES)
        MINUTES = []
        1.upto(59) do |m| 
          MINUTES << [(m < 10 ? "0#{m}" : m), m]
        end
      end
      
      # This will create a series of select boxes that compromise a time object. By default boxes will be
      # created for day/month/year hour:minute. You can optionally turn on or off any of these boxes, including
      # seconds by setting them to true/false. For example:
      #   <%= date_time_select :some_time, :days => false %>
      # will not produce a select box for days, and so on...
      # 
      # You can pass in an array of arrays to represent the options for any of the boxes like such:
      #   <%= date_time_select :some_time, :day_options => [[1,"one"], [2,"two"]] %>
      # Will produce a day select box with only two options. Alternatively you can pass in an array of values
      # and the options will be done for you. Like such:
      #   <%= date_time_select :some_time, :day_values => 1..60 %>
      # Will produce a day select box with 60 options whose values and keys will be the same.
      # 
      # The separators for dates and times can be set with the date_separator and time_separator options. By
      # default they are:
      #   :date_separator => '/'
      #   :time_separator => ':'
      def date_time_select(name, *args)
        var = instance_variable_get("@#{name}")
        fe = FormElement.new(*args)
        
        time = var if var.is_a?(Time) || var.is_a?(Date)
        time = var.nil? ? Time.now : (var.send(fe.calling_method) || Time.now) if time.nil?
        
        years = []
        (time.year - 5).upto(time.year + 5) { |y| years << [y, y]}
        
        options = {:years => true, :months => true, :days => true, :hours => true, :minutes => true, :seconds => false, :year_options => years, :month_options => MONTHS, :day_options => DAYS, :hour_options => HOURS, :minute_options => MINUTES, :second_options => MINUTES, :date_separator => '/', :time_separator => ':'}.merge(fe.options)
        
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
        
        boxes = date_boxes.join(options[:date_separator])
        
        unless time_boxes.empty?
          boxes << " " << time_boxes.join(options[:time_separator])
        end
        
        return label + boxes
      end
      
      # Used just like date_time_select, but it has hours, minutes, and seconds turned off. See date_time_select
      # for more options.
      # 
      #   @user = User.new
      #   <%= :user.date_select :birth_date %>
      #   @some_time = Time.new
      #   <%= :date_select :some_time, :label => true %>
      def date_select(name, *args)
        fe = FormElement.new(*args)
        date_time_select(name, fe.calling_method, {:hours => false, :minutes => false, :seconds => false}.merge(fe.options))
      end
      
      private
      def dt_select(col, name, fe, selected, values)
        options = {:name => name, :id => name}
        unless fe.calling_method == :to_s
          options.merge!(:name => "#{name}[#{fe.calling_method}(#{col})]", :id => "#{name}_#{fe.calling_method}_#{col}")
        else
          options.merge!(:name => "#{name}(#{col})", :id => "#{name}_#{col}")
        end
        options.merge!(:options => values, :selected => selected)
        select_tag(name, fe.options.merge(options))
      end
      
    end # DateTimeHelpers
  end # ViewHelpers
end # Mack
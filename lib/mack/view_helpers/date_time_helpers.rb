module Mack
  module ViewHelpers # :nodoc:
    module DateTimeHelpers
      
      MONTHS = [["January", 1], ["February", 2], ["March", 3], ["April", 4], ["May", 5], ["June", 6], ["July", 7], ["August", 8], 
                ["September", 9], ["October", 10], ["November", 11], ["December", 12]]
      DAYS = []
      1.upto(31) {|m| DAYS << [m, m]}
      HOURS = []
      1.upto(24) {|h| HOURS << [h, h]}
      MINUTES = []
      1.upto(59) {|m| MINUTES << [m, m]}
      
      def date_time_select(name, *args)
        var = instance_variable_get("@#{name}")
        fe = FormElement.new(*args)
        time = var.nil? ? Time.now : var.send(fe.calling_method)
        # years = ((time.year - 5)..(time.year + 5)).to_a
        years = []
        (time.year - 5).upto(time.year + 5) { |y| years << [y, y]}
        
        "#{dt_select(:year, name, fe, time.year, years)} / #{dt_select(:month, name, fe, time.month, MONTHS)} / #{dt_select(:day, name, fe, time.day, DAYS)} #{dt_select(:hour, name, fe, time.hour, HOURS)}:#{dt_select(:minute, name, fe, time.min, MINUTES)}"
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
      
      
      class FormElement # :nodoc:

        attr_accessor :calling_method
        attr_accessor :options

        def initialize(*args)
          args = args.parse_splat_args
          self.calling_method = :to_s
          self.options = {}
          case args
          when Symbol, String
            self.calling_method = args
          when Hash
            self.options = args
          when Array
            self.calling_method = args[0]
            self.options = args[1]
          when nil
          else
            raise ArgumentError.new("You must provide either a Symbol, a String, a Hash, or a combination thereof.")
          end
          if self.options[:checked]
            self.options[:checked] = :checked
          end
        end

      end
      
    end # DateTimeHelpers
  end # ViewHelpers
end # Mack
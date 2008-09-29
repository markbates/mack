module Test # :nodoc:
  module Unit # :nodoc:
    class TestCase # :nodoc:
      
      def name # :nodoc:
        "#{self.class.name}\t\t#{@method_name}"
      end
      
      # Let's alias the run method in the class above us so we can create a new one here
      # but still reference it.
      alias_instance_method :run, :super_run # :nodoc:

      # We need to wrap the run method so we can do things like
      # run a cleanup method if it exists
      def run(result, &progress_block) # :nodoc:
        super_run(result) do |state, name|
          in_session do
            if state == Test::Unit::TestCase::STARTED
              cleanup if self.respond_to?(:cleanup)
              log_start(name)
            else
              cleanup if self.respond_to?(:cleanup)
              log_end(name)
            end
          end
        end
      end
      
      def log_start(name = "")
        @log_start_time = Time.now      
        puts "\n#{format_log_time(@log_start_time)}: Starting\t#{name}"
      end

      def log_end(name = "")                 
        @log_end_time = Time.now
        puts "#{format_log_time(@log_end_time)}: Ending\t#{name}"
        et = @log_end_time - @log_start_time
        suffix = ""
        et.round.times { suffix += "!" } if et > 1.0
        if et > 0.5
          puts "#{suffix}Elapsed Time: #{et} seconds#{suffix}"
        end
      end
      
      private
      def format_log_time(time = Time.now)
        time.strftime("%I:%M:%S %p")
      end
      
    end # TestCase
  end # Unit
end # Test
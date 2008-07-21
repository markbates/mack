module Mack
  module RunnerHelpers
    class RequestLogger
      
      attr_reader :start_time
      attr_reader :end_time
      attr_reader :total_time
      attr_reader :requests_per_second
      
      def initialize(start_logger = true)
        start if start_logger
      end
      
      def start
        @start_time = Time.now
      end
      
      def complete(request, response)
        @end_time = Time.now
        @total_time = @end_time - @start_time
        @requests_per_second = (1 / @total_time).round
        if app_config.log.detailed_requests
          msg = "\n\t[#{request.request_method.upcase}] '#{request.path_info}'\n"
          msg << "\tSession ID: #{request.session.id}\n" if app_config.mack.use_sessions
          msg << "\tParameters: #{request.all_params}\n"
          msg << "\tCompleted in #{@total_time} (#{@requests_per_second} reqs/sec) | #{response.status} [#{request.full_host}]"
        else
          msg = "[#{request.request_method.upcase}] '#{request.path_info}' (#{total_time})"
        end
        Mack.logger.info(msg)
      end
      
    end # RequestLogger
  end # Utils
end # Mack
require File.join(File.dirname(__FILE__), "base")
module Mack
  module RunnerHelpers # :nodoc:
    class RequestLogger < Mack::RunnerHelpers::Base
      
      attr_reader :start_time
      attr_reader :end_time
      attr_reader :total_time
      attr_reader :requests_per_second
      
      def start(request, response, cookies)
        @start_time = Time.now
      end
      
      def complete(request, response, cookies)
        @end_time = Time.now
        @total_time = @end_time - @start_time
        @requests_per_second = (1 / @total_time).round
        if configatron.log.detailed_requests
          msg = "\n\t[#{request.params[:method].to_s.upcase}] '#{request.path_info}'\n"
          msg << "\tSession ID: #{request.session.id}\n" if configatron.mack.use_sessions
          msg << "\tParameters: #{request.all_params}\n"
          msg << Mack::Utils::Ansi::Color.wrap(configatron.log.completed_color, "\tCompleted in #{@total_time} (#{@requests_per_second} reqs/sec) | #{response.status} [#{request.full_host}]")
        else
          msg = "[#{request.request_method.upcase}] '#{request.path_info}' (#{total_time})"
        end
        Mack.logger.info(msg)
      end
      
    end # RequestLogger
  end # RunnerHelpers
end # Mack
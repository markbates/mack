require File.join(File.dirname(__FILE__), "request_logger")
require File.join(File.dirname(__FILE__), "session")
module Mack
  module RunnerHelpers
    class Registry < Mack::Utils::Registry
      
      def initial_state
        [Mack::RunnerHelpers::RequestLogger, Mack::RunnerHelpers::Session]
      end
      
    end
  end
end
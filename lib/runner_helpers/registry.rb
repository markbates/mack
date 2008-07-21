require File.join(File.dirname(__FILE__), "request_logger")
require File.join(File.dirname(__FILE__), "session")
module Mack
  module RunnerHelpers
    class Registry
      include Singleton
      
      attr_accessor :runner_helpers
      
      def initialize
        self.runner_helpers = [Mack::RunnerHelpers::RequestLogger, Mack::RunnerHelpers::Session]
      end
      
      def add(klass)
        self.runner_helpers << klass
        self.runner_helpers.uniq!
        self.runner_helpers.compact!
      end
      
      class << self
        
        def add(klass)
          Mack::RunnerHelpers::Registry.instance.add(klass)
        end
        
        def remove(klass)
          Mack::RunnerHelpers::Registry.instance.runner_helpers.delete(klass)
        end
        
      end
      
    end
  end
end
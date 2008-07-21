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
      
      def add(klass, position = self.runner_helpers.size)
        self.runner_helpers.insert(position, klass)
        # self.runner_helpers << klass
        self.runner_helpers.uniq!
        self.runner_helpers.compact!
      end
      
      class << self
        
        def helpers
          Mack::RunnerHelpers::Registry.instance.runner_helpers
        end
        
        def add(klass, position = helpers.size)
          Mack::RunnerHelpers::Registry.instance.add(klass, position)
        end
        
        def remove(klass)
          helpers.delete(klass)
        end
        
        def move_to_top(klass)
          Mack::RunnerHelpers::Registry.instance.add(klass, 0)
        end
        
        def move_to_bottom(klass)
          remove(klass)
          Mack::RunnerHelpers::Registry.instance.add(klass)
        end
        
      end
      
    end
  end
end
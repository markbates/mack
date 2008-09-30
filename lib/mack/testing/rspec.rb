require File.join(File.dirname(__FILE__), "helpers")

require 'spec'
module Spec # :nodoc:
  module Example # :nodoc:
    module ExampleMethods # :nodoc:
      include Mack::Routes::Urls
      include Mack::Testing::Helpers
    
      alias_instance_method :eval_block, :mack_eval_block

      def eval_block
        in_session do
          mack_eval_block
        end
      end
    
    end # ExampleMethods
  end # Example
  
  module Matchers # :nodoc:
    def match(regexp)
      regexp = /#{regexp}/ if regexp.is_a?(String)
      Matchers::Match.new(regexp)
    end
  end # Matchers
  
end # Spec

require File.join(File.dirname(__FILE__), "helpers")

require 'spec'
module Spec # :nodoc:
  module Example # :nodoc:
    module ExampleMethods # :nodoc:
      include Mack::Routes::Urls
      include Mack::Testing::Helpers
    
      alias_instance_method :run_with_description_capturing, :mack_run_with_description_capturing

      def run_with_description_capturing
        begin
            in_session do
              instance_eval(&(@_implementation || PENDING_EXAMPLE_BLOCK))
            end
        ensure
          @_matcher_description = Spec::Matchers.generated_description
          Spec::Matchers.clear_generated_description
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

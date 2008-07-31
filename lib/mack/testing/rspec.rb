require File.join(File.dirname(__FILE__), "helpers")

require 'spec'
module Spec # :nodoc:
  module Example # :nodoc:
    module ExampleMethods # :nodoc:
      include Mack::Routes::Urls
      include Mack::Testing::Helpers
    
      alias_method :mack_spec_execute, :execute

      def execute(options, instance_variables)
        in_session do
          @__res = mack_spec_execute(options, instance_variables)
        end
        @__res
      end
    
    end
  end
end
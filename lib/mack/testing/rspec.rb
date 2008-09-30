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
  
  require 'spec/runner/formatter/base_text_formatter'
  module Runner # :nodoc:
    module Formatter # :nodoc:
      class BaseTextFormatter < BaseFormatter # :nodoc:

        def dump_pending
          unless @pending_examples.empty?
            @output.puts
            @output.puts yellow("Pending:")
            @pending_examples.each do |pending_example|
              @output.puts yellow("#{pending_example[0]} (#{pending_example[1]})")
              # @output.puts "  Called from #{pending_example[2]}"
            end
          end
          @output.flush
        end
        
      end # BaseTextFormatter
    end # Formatter
  end # Runner
  
end # Spec



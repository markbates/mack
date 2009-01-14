module Treetop
  module Compiler    
    class Terminal < AtomicExpression
      def compile(address, builder, parent_expression = nil)
        super
        string_length = eval(text_value).length
        
        builder.if__ "input.index(#{text_value}, index) == index" do
          assign_result "(#{node_class_name}).new(input, index...(index + #{string_length}))"
          extend_result_with_inline_module
          builder << "@index += #{string_length}"
        end
        builder.else_ do
          builder << "terminal_parse_failure(#{text_value})"
          assign_result 'nil'
        end
      end
    end
 end
end
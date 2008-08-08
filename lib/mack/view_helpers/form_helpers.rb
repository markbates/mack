module Mack
  module ViewHelpers # :nodoc:
    module FormHelpers
      
      def form(action, options = {}, &block)
        options = {:method => :post, :action => action}.merge(options)
        if options[:id]
          options = {:class => options[:id]}.merge(options)
        end
        if options[:multipart]
          options = {:enctype => "multipart/form-data"}.merge(options)
          options.delete(:multipart)
        end
        meth = nil
        unless options[:method] == :get || options[:method] == :post
          meth = "<input name=\"_method\" type=\"hidden\" value=\"#{options[:method]}\" />\n"
          options[:method] = :post
        end
        concat("<form#{build_options(options)}>\n", block.binding)
        concat(meth, block.binding) unless meth.blank?
        yield
        concat("</form>", block.binding)
        # content_tag(:form, options, &block)
      end
      
      # Builds an HTML submit tag
      def submit_tag(value = "Submit", options = {})
        non_content_tag(:input, {:type => :submit, :value => value}.merge(options))
      end
      
      
    end # FormHelpers
  end # ViewHelpers
end # Mack
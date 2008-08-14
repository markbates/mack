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
      
      def submit_tag(value = "Submit", options = {}, *original_args)
        Mack.logger.warn("DEPRECATED: 'submit_tag'. Please use 'submit' instead")
        submit(value, options, *original_args)
      end
      
      # Builds an HTML submit tag
      def submit(value = "Submit", options = {}, *original_args)
        non_content_tag(:input, {:type => :submit, :value => value}.merge(options))
      end
      
      def check_box(name, *args)
        build_form_element(name, {:type => :checkbox}, *args) do |var, fe, options|
          if options[:value]
            options.merge!(:checked => "checked")
          end
          options.delete(:value)
        end
      end

      def file_field(name, *args)
        build_form_element(name, {:type => :file}, *args)
      end

      def hidden_field(name, *args)
        build_form_element(name, {:type => :hidden}, *args)
      end

      def image_submit(src, options = {})
        non_content_tag(:input, {:type => :image, :src => "/images/#{src}"}.merge(options))
      end

      def label(name, *args)
        fe = FormElement.new(*args)
        unless fe.options[:for]
          fe.options[:for] = (fe.calling_method == :to_s ? name.to_s : "#{name}_#{fe.calling_method}")
        end
        unless fe.options[:value]
          fe.options[:value] = (fe.calling_method == :to_s ? name.to_s.humanize : fe.calling_method.to_s.humanize)
        end
        content = fe.options[:value]
        fe.options.delete(:value)
        content_tag(:label, fe.options, content)
      end

      def radio_button(name, *args)
        build_form_element(name, {:type => :radio}, *args) do |var, fe, options|
          if options[:value]
            options.merge!(:checked => "checked")
          end
          options.delete(:value)
        end
      end

      def select(name, *args)
        var = instance_variable_get("@#{name}")
        fe = FormElement.new(*args)
        options = {:name => name, :id => name}
        unless fe.calling_method == :to_s
          options.merge!(:name => "#{name}[#{fe.calling_method}]", :id => "#{name}_#{fe.calling_method}")
        end

        content = ""

        opts = fe.options[:options]
        unless opts.nil?
          sopts = opts
          if opts.is_a?(Array)
          elsif opts.is_a?(Hash)
            sopts = []
            opts.sort.each do |k,v|
              sopts << [k, v]
            end
          else
            raise ArgumentError.new(":options must be either an Array of Arrays or a Hash!")
          end
          sel_value = var.send(fe.calling_method) if var
          sel_value = fe.options[:selected] if fe.options[:selected]
          sopts.each do |kv|
            content << %{<option value="#{kv[1]}" #{kv[1].to_s == sel_value.to_s ? "selected" : ""}>#{kv[0]}</option>}
          end
          fe.options.delete(:selected)
          fe.options.delete(:options)
        end
        
        return content_tag(:select, options.merge(fe.options), content)
      end

      def text_area(name, *args)
        var = instance_variable_get("@#{name}")
        fe = FormElement.new(*args)
        options = {:name => name, :id => name}
        if var.nil?
          return content_tag(:textarea, options.merge(fe.options))
        else
          unless fe.calling_method == :to_s
            options.merge!(:name => "#{name}[#{fe.calling_method}]", :id => "#{name}_#{fe.calling_method}")
          end
          options[:value] = var.send(fe.calling_method)
          
          yield var, fe, options if block_given?
          
          content = options[:value]
          options.delete(:value)
          
          return content_tag(:textarea, options.merge(fe.options), content)
        end
      end

      def text_field(name, *args)
        build_form_element(name, {:type => :text}, *args)
      end
      
      def password_field(name, *args)
        build_form_element(name, {:type => :password}, *args)
      end
      
      private
      def build_form_element(name, options, *original_args)
        var = instance_variable_get("@#{name}")
        options = {:name => name, :id => name}.merge(options)
        if var.nil?
          return non_content_tag(:input, options)
        else
          fe = FormElement.new(*original_args)
          unless fe.calling_method == :to_s
            options.merge!(:name => "#{name}[#{fe.calling_method}]", :id => "#{name}_#{fe.calling_method}")
          end
          options[:value] = var.send(fe.calling_method)
          
          yield var, fe, options if block_given?
          
          return non_content_tag(:input, options.merge(fe.options))
        end
      end
      
      class FormElement

        attr_accessor :calling_method
        attr_accessor :options

        def initialize(*args)
          args = args.parse_splat_args
          self.calling_method = :to_s
          self.options = {}
          case args
          when Symbol, String
            self.calling_method = args
          when Hash
            self.options = args
          when Array
            self.calling_method = args[0]
            self.options = args[1]
          when nil
          else
            raise ArgumentError.new("You must provide either a Symbol, a String, a Hash, or a combination thereof.")
          end
        end

      end
      
      
    end # FormHelpers
  end # ViewHelpers
end # Mack
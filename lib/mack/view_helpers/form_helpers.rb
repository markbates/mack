module Mack
  module ViewHelpers # :nodoc:
    # A useful collection of helpers for forms.
    module FormHelpers
      
      #
      # Get the secret token to be added in an HTML form.
      # This is to ensure that your form is valid.
      # 
      # Only call this method if you generate the form manually.
      # If you use the form() method to generate your form, then
      # the authenticity token is already included in your form.
      #
      def form_authenticity_field
        str = %{<input type="hidden" name="__authenticity_token" value="#{Mack::Utils::AuthenticityTokenDispenser.instance.dispense_token(request.session.id)}" />\n}
      end
        
      
      # Examples:
      #   <% form(users_create_url) do -%>
      #     # form stuff here...
      #   <% end -%>
      # 
      #   <% form(users_update_url, :method => :put) do -%>
      #     # form stuff here...
      #   <% end -%>
      # 
      #   <% form(photos_create_url, :multipart => true) do -%>
      #     # form stuff here...
      #   <% end -%>
      def form(action, options = {}, &block)
        options = {:method => :post, :action => action}.merge(options)
        form_builder = options.delete(:builder) || configatron.mack.default_form_builder.camelcase.constantize.new(Thread.current[:view_template])
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
        concat(form_authenticity_field, block.binding) unless configatron.mack.disable_forgery_detector
        yield form_builder
        concat("\n</form>", block.binding)
        # content_tag(:form, options, &block)
      end
      
      # Generates a button with a form around it and will set the request method to delete.
      def delete_button(url, value = "Delete", form_options = {}, button_options = {})
        t = "\n" << hidden_field(:_method, :value => :delete)
        t << "\n" << submit_button(value, button_options)
        t << "\n"
        content_tag(:form, {:action => url, :method => :post}.merge(form_options), t)
      end
      
      # Examples:
      #   <%= submit_button %> # => <input type="submit" value="Submit" />
      #   <%= submit_button "Login" %> # => <input type="submit" value="Login" />
      #   You can disable the button after clicking it. In essence, this will work as follows:
      #   <%= submit_button "Login", :disable_with => "Please wait..." %> 
      #    # => <input type="submit" value="Login" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" />
      #  Even though :disable_with will work on the onclick parameter, you can add your own onclick behaviour to the mix, as follows:
      #  <%= submit_button "Login", :disable_with => "Please wait...", :onclick => "alert('test')" %> 
      #    # => <input type="submit" value="Login" onclick="this.disabled=true;this.value='Please wait...';alert('test');this.form.submit();" />
      #
      # Please note that if the form.submit() returns false the button's value will be restored to 
      # its initial value. This behaviour is acheived through the injection of a couple bits of JS 
      # into the onlick existing parameter. These bits are injected after the disabled value, and 
      # all existing onclick behaviour that you define in the :onlick option. The included JS bits 
      # are as follows:
      #   "result = (this.form.onsubmit ? (this.form.onsubmit() ? this.form.submit() : false) : this.form.submit())",
      #   "if (result == false) { this.value = this.getAttribute('originalValue'); this.disabled = false }",
      #   "return result;"
      def submit_button(value = "Submit", options = {}, *original_args)
        if options[:confirm]
          onclick = "if (confirm('#{options.delete(:confirm)}')) {submit();}; return false;"
          onclick << ";#{options.delete(:onclick)}" if options.has_key?(:onclick)
          options[:onclick] = onclick
        end
        # processing the disable with option, which will be embebed in the onclick parameter.
        if disable_with = options.delete(:disable_with)
          disable_with = "this.innerHTML='#{disable_with}'"
          
          # Making sure that we keep the content of the onclick option, should it exist.
          disable_with << ";#{options.delete(:onclick)}" if options.has_key?(:onclick)
          
          # Setting the onlick option.
          options[:onclick] = [
            "this.setAttribute('originalValue', this.innerHTML)",
            "this.disabled=true",
            disable_with,
            "result = (this.form.onsubmit ? (this.form.onsubmit() ? this.form.submit() : false) : this.form.submit())",
            "if (result == false) { this.innerHTML = this.getAttribute('originalValue'); this.disabled = false }",
            "return result;",
          ].join(";")
        end
        
        # non_content_tag(:input, {:type => :submit, :value => value}.merge(options))
        content_tag(:button, {:type => :submit}.merge(options), value)
      end
      
      # Examples:
      #   @user = User.new(:accepted_tos => true)
      #   <%= check_box :user, :accepted_tos %> # => <input checked="checked" id="user_accepted_tos" name="user[accepted_tos]" type="checkbox" />
      #   <%= check_box :i_dont_exist %> # => <input id="i_dont_exist" name="i_dont_exist" type="checkbox" />
      def check_box(name, *args)
        build_form_element(name, {:type => :checkbox}, *args) do |var, fe, options|
          if options[:value]
            options.merge!(:checked => "checked")
          end
          options.delete(:value)
        end
      end
      
      # Examples:
      #   @user = User.new(:bio_file => "~/bio.doc")
      #   <%= file_field :user, :bio_file %> # => <input id="user_bio_field" name="user[bio_field]" type="file" value="~/bio.doc" />
      #   <%= file_field :i_dont_exist %> # => <input id="i_dont_exist" name="i_dont_exist" type="file" value="" />
      def file_field(name, *args)
        build_form_element(name, {:type => :file}, *args)
      end

      # Examples:
      #   @user = User.new(:email => "mark@mackframework.com")
      #   <%= hidden_field :user, :email %> # => <input id="user_email" name="user[email]" type="hidden" value="mark@mackframework.com" />
      #   <%= hidden_field :i_dont_exist %> # => <input id="i_dont_exist" name="i_dont_exist" type="hidden" />
      def hidden_field(name, *args)
        build_form_element(name, {:type => :hidden}, *args)
      end
      
      # Examples:
      #   <%= image_submit "logo.png" %> # => <input src="/images/logo.png" type="image" />
      def image_submit(src, options = {})
        non_content_tag(:input, {:type => :image, :src => "/images/#{src}"}.merge(options))
      end

      # Examples:
      #   @user = User.new(:level => 1)
      #   <%= select_tag :user, :level, :options => [["one", 1], ["two", 2]] %> # => <select id="user_level" name="user[level]"><option value="1" selected>one</option><option value="2" >two</option></select>
      #   <%= select_tag :user :level, :options => {:one => 1, :two => 2} %> # => <select id="user_level" name="user[level]"><option value="1" selected>one</option><option value="2" >two</option></select>
      #   <%= select_tag :i_dont_exist :options => [["one", 1], ["two", 2]], :selected => 1 %> # => <select id="i_dont_exist" name="i_dont_exist"><option value="1" selected>one</option><option value="2" >two</option></select>
      def select_tag(name, *args)
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
            selected = kv[1].to_s == sel_value.to_s ? "selected" : ""
            content << %{\n<option value="#{kv[1]}" #{selected}>#{kv[0]}</option>}
          end
          fe.options.delete(:selected)
          fe.options.delete(:options)
        end
        
        return label_parameter_tag(name, options[:id], var, fe) + content_tag(:select, options.merge(fe.options), content)
      end
      
      # Examples:
      #   @user = User.new(:bio => "my bio here")
      #   <%= text_area :user, :bio %> # => <textarea id="user_bio" name="user[bio]">my bio here</textarea>
      #   <%= text_area :i_dont_exist %> # => <textarea id="i_dont_exist" name="i_dont_exist"></textarea>
      #   <%= text_area :i_dont_exist :value => "hi there" %> # => <textarea id="i_dont_exist" name="i_dont_exist">hi there</textarea>
      def text_area(name, *args)
        var = instance_variable_get("@#{name}")
        fe = FormElement.new(*args)
        options = {:name => name, :id => name, :cols => 60, :rows => 20}
        if var.nil?
          value = fe.options[:value]
          fe.options.delete(:value)
          return label_parameter_tag(name, options[:id], var, fe) + content_tag(:textarea, options.merge(fe.options), value)
        else
          unless fe.calling_method == :to_s
            options.merge!(:name => "#{name}[#{fe.calling_method}]", :id => "#{name}_#{fe.calling_method}")
          end
          options[:value] = var.send(fe.calling_method)
          
          yield var, fe, options if block_given?
          
          content = options[:value]
          options.delete(:value)
          
          return label_parameter_tag(name, options[:id], var, fe) + content_tag(:textarea, options.merge(fe.options), content)
        end
      end
      
      # Examples:
      #   @user = User.new(:email => "mark@mackframework.com")
      #   <%= text_field :user, :email %> # => <input id="user_email" name="user[email]" type="text" value="mark@mackframework.com" />
      #   <%= text_field :i_dont_exist %> # => <input id="i_dont_exist" name="i_dont_exist" type="text" />
      def text_field(name, *args)
        build_form_element(name, {:type => :text}, *args)
      end
      
      # Examples:
      #   @user = User.new(:email => "mark@mackframework.com")
      #   <%= password_field :user, :email %> # => <input id="user_email" name="user[email]" type="password" value="mark@mackframework.com" />
      #   <%= password_field :i_dont_exist %> # => <input id="i_dont_exist" name="i_dont_exist" type="password" />
      def password_field(name, *args)
        build_form_element(name, {:type => :password}, *args)
      end
      
      # Examples:
      #   @user = User.new(:level => 1)
      #   <%= radio_button :user, :level %> # => <input checked="checked" id="user_level" name="user[level]" type="radio" value="1" />
      #   <%= radio_button :user, :level, :value => 2 %> # => <input id="user_level" name="user[level]" type="radio" value="2" />
      #   <%= radio_button :i_dont_exist %> # => <input id="i_dont_exist" name="i_dont_exist" type="radio" value="" />
      def radio_button(name, *args)
        build_form_element(name, {:type => :radio, :value => ""}, *args) do |var, fe, options|
          if fe.options[:value]
            if fe.options[:value] == options[:value]
              options.merge!(:checked => "checked")
            end
          elsif options[:value]
            options.merge!(:checked => "checked")
          end
        end
      end
      
      # Examples:
      #   @user = User.new
      #   <%= label_tag :user, :email %> # => <label for="user_email">Email</label>
      #   <%= label_tag :i_dont_exist %> # => <label for="i_dont_exist">I don't exist</label>
      #   <%= label_tag :i_dont_exist, :value => "Hello" %> # => <label for="i_dont_exist">Hello</label>
      def label_tag(name, *args)
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
      
      private
      def label_parameter_tag(name, id, var, fe)
        label = ''
        if fe.options[:label]
          if fe.options[:label].is_a?(TrueClass)
            if var.nil?
              label = %{<label for="#{id}">#{name.to_s.humanize}</label>\n}
            else
              label = %{<label for="#{id}">#{fe.calling_method.to_s.humanize}</label>\n}
            end
          else
            label = %{<label for="#{id}">#{fe.options[:label]}</label>\n}
          end
          fe.options.delete(:label)
        end
        return label
      end
      
      def build_form_element(name, options, *original_args) # :nodoc:
        var = instance_variable_get("@#{name}")
        fe = FormElement.new(*original_args)
        options = {:name => name, :id => name}.merge(options)
        if var.nil?
          return label_parameter_tag(name, options[:id], var, fe) + non_content_tag(:input, options.merge(fe.options))
        else
          unless fe.calling_method == :to_s
            options.merge!(:name => "#{name}[#{fe.calling_method}]", :id => "#{name}_#{fe.calling_method}")
          end
          options[:value] = var.send(fe.calling_method)
          
          if var.has_errors?(fe.calling_method)
            fe.options = {:error_class => "error"}.merge(fe.options)
            class_arr = fe.options[:class].to_s.split(" ").collect { |s| s.strip }
            class_arr << fe.options[:error_class]
            fe.options[:class] = class_arr.join(" ")
          end
          
          yield var, fe, options if block_given?
          
          # we don't need the error_class by this time, since if used it will get appended into options[:class]
          fe.options.delete(:error_class)
          return label_parameter_tag(name, options[:id], var, fe) + non_content_tag(:input, options.merge(fe.options))
        end
      end
      
      class FormElement # :nodoc:

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
          if self.options[:checked]
            self.options[:checked] = :checked
          end
        end

      end
      
      
    end # FormHelpers
  end # ViewHelpers
end # Mack
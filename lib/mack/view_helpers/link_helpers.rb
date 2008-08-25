module Mack
  module ViewHelpers # :nodoc:
    module LinkHelpers
      
      # Generates a javascript popup window. It will create the javascript needed for the window,
      # as well as the href to call it.
      # 
      # Example:
      #   popup('click here', 'http://www.example.com', {:toolbar => :yes, :name => :example_window}, {:alt => 'hello'}) # => 
      #   <script>
      #     function popup_r8b3edqgpbhm3zkthlgp(u) {
      #       window.open(u, 'example_window', "height=400,location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,titlebar=no,toolbar=yes,width=500");
      #     }
      #   </script>
      #   <a alt="hello" href="javascript:popup_r8b3edqgpbhm3zkthlgp('http://www.example.com')">click here</a>
      def popup(link_text, url = link_text, popup_options = {}, html_options = {})
        m = String.randomize(20).downcase
        popup_options = {:menubar => :no, :width => 500, :height => 400, :toolbar => :no, :scrollbars => :yes, :resizable => :yes, :titlebar => :no, :status => :no, :location => :no, :name => m}.merge(popup_options)
        window_name = popup_options[:name]
        popup_options.delete(:name)
        %{
<script>
  function popup_#{m}(u) {
    window.open(u, '#{window_name}', "#{popup_options.join("%s=%s", ",")}");
  }
</script>
#{link_to(link_text, "javascript:popup_#{m}('#{url}')", html_options)}
        }.strip
      end
      
      # This is just an alias to the a method
      # 
      # Examples:
      #   <%= link_to("http://www.mackframework.com") %> # => <a href="http://www.mackframework.com">http://www.mackframework.com</a>
      #   <%= link_to("Mack", "http://www.mackframework.com") %> # => <a href="http://www.mackframework.com">Mack</a>
      #   <%= link_to("Mack", "http://www.mackframework.com", :target => "_blank") %> # => <a href="http://www.mackframework.com" target="_blank">Mack</a>
      #   <%= link_to("Mack", "http://www.mackframework.com", :target => "_blank", :rel => :nofollow) %> # => <a href="http://www.mackframework.com" target="_blank" rel="nofollow">Mack</a>
      # If you pass in :method as an option it will be a JavaScript form that will post to the specified link with the 
      # methd specified.
      #   <%= link_to("Mack", "http://www.mackframework.com", :method => :delete) %>
      # If you use the :method option you can also pass in a :confirm option. The :confirm option will generate a 
      # javascript confirmation window. If 'OK' is selected the the form will submit. If 'cancel' is selected, then
      # nothing will happen. This is extremely useful for 'delete' type of links.
      #   <%= link_to("Mack", "http://www.mackframework.com", :method => :delete, :confirm => "Are you sure?") %>
      def link_to(link_text, url = link_text, html_options = {})
        options = {:href => url}.merge(html_options)
        a(link_text, options)
      end
      
      # Used in views to create href links. It takes link_text, url, and a Hash that gets added
      # to the href as options.
      # 
      # Examples:
      #    a("http://www.mackframework.com") # => <a href="http://www.mackframework.com">http://www.mackframework.com</a>
      #    a("Mack", :href => "http://www.mackframework.com") # => <a href="http://www.mackframework.com">Mack</a>
      #    a("Mack", :href => "http://www.mackframework.com", :target => "_blank") # => <a href="http://www.mackframework.com" target="_blank">Mack</a>
      #    a("Mack", :href => "http://www.mackframework.com", :target => "_blank", :rel => :nofollow) # => <a href="http://www.mackframework.com" target="_blank" rel="nofollow">Mack</a>
      # If you pass in :method as an option it will be a JavaScript form that will post to the specified link with the 
      # methd specified.
      #    a("Mack", :href => "http://www.mackframework.com", :method => :delete)
      # If you use the :method option you can also pass in a :confirm option. The :confirm option will generate a 
      # javascript confirmation window. If 'OK' is selected the the form will submit. If 'cancel' is selected, then
      # nothing will happen. This is extremely useful for 'delete' type of links.
      #    a("Mack", :href => "http://www.mackframework.com", :method => :delete, :confirm => "Are you sure?")
      def a(link_text, options = {})
        options = {:href => link_text}.merge(options)
        if options[:method]
          meth = nil
          confirm = nil
        
          meth = %{var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;var s = document.createElement('input'); s.setAttribute('type', 'hidden'); s.setAttribute('name', '_method'); s.setAttribute('value', '#{options[:method]}'); f.appendChild(s);f.submit()}
          options.delete(:method)
        
          if options[:confirm]
            confirm = %{if (confirm('#{options[:confirm]}'))}
            options.delete(:confirm)
          end
        
          options[:onclick] = (confirm ? (confirm + " { ") : "") << meth << (confirm ? (" } ") : "") << ";return false;"
        end
        content_tag(:a, options, link_text)
      end
      
      # Wraps an image tag with a link tag.
      # 
      # Examples:
      #   <%= link_image_to("/images/foo.jpg", "#" %> # => <a href="#"><img src="/images/foo.jpg"></a>
      def link_image_to(image_url, url, image_options = {}, html_options = {})
        link_to(img(image_url, image_options), url, html_options)
      end
      
      # Builds a mailto href. By default it will generate 
      # JavaScript to help prevent phishing. To turn this off
      # pass in the option :format => :plain
      # 
      #   mail_to("Saul Frami", "frami.saul@klocko.ca") # => 
      #   <script>document.write(String.fromCharCode(60,97,32,104,114,101,
      #   102,61,34,109,97,105,108,116,111,58,102,114,97,109,105,46,115,97,117,
      #   108,64,107,108,111,99,107,111,46,99,97,34,62,83,97,117,108,32,70,114,97,109,105,60,47,97,62));</script>
      def mail_to(text, email_address = nil, options = {})
        email_address = text if email_address.blank?
        options = {:format => :js}.merge(options)
        format = options[:format]
        options - [:format]
        link = link_to(text, "mailto:#{email_address}", options)
        if format == :js
          y = ''
          link.size.times {y << 'a'}
          js_link = "<script>"
          c_code = []
          link.each_byte {|c| c_code << c}
          js_link << "document.write(String.fromCharCode(#{c_code.join(",")}));"
          js_link << "</script>"
          return js_link
        else
          return link
        end
      end
      
      #
      # Generate Javascript tag (<javascript src="/javascripts/foo.js?1241225" type="text/javascript" />)
      #
      # If distributed_site_domain is specified, it will be used.
      #
      def javascript(files, options = {})
        files = [files].flatten
        options = {:type => "text/javascript"}.merge(options)
        
        link = ""
        files.each do |name|
          file_name = !name.to_s.end_with?(".js") ? "#{name}.js" : "#{name}"
          resource = "/javascripts/#{file_name}"
          link += "<javascript src=\"#{get_resource_root(resource)}#{resource}?#{Time.now.to_i}\" type=\"#{options[:type]}\" />\n"
        end
        return link
      end
      
      #
      # Generate Stylesheet tag
      # If distributed_site_domain is specified, then it will use it as the host of the css file
      # example:
      # stylesheet("foo") => <link href="/stylesheets/scaffold.css" media="screen" rel="stylesheet" type="text/css" />
      # 
      # distributed_site_domain is set to 'http://localhost:3001'
      # then, stylesheet("foo") will generate
      # <link href="http://localhost:3001/stylesheets/scaffold.css" media="screen" rel="stylesheet" type="text/css" />
      #
      # Supported options are: :media, :rel, and :type
      #
      def stylesheet(files, options = {})
        files = [files].flatten
        options = {:media => 'screen', :rel => 'stylesheet', :type => 'text/css'}.merge(options)
        
        link = ""
        files.each do |name|
          file_name = !name.to_s.end_with?(".css") ? "#{name}.css" : "#{name}"
          resource = "/stylesheets/#{file_name}"
          link += "<link href=\"#{get_resource_root(resource)}#{resource}\" media=\"#{options[:media]}\" rel=\"#{options[:rel]}\" type=\"#{options[:type]}\" />\n"
        end
        
        return link
      end
      
      private
      def get_resource_root(resource)
        path = ""
        path = "#{app_config.mack.distributed_site_domain}" if app_config.mack.distributed_site_domain
        path = Mack::AssetHelpers.instance.asset_hosts(resource) if path.empty?
        return path
      end
      
    end # LinkHelpers
  end # ViewHelpers
end # Mack
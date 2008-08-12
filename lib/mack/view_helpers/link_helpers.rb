module Mack
  module ViewHelpers # :nodoc:
    module LinkHelpers
      
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
      # Generate Stylesheet tag
      # If distributed_site_domain is specified, then it will use it as the host of the css file
      # example:
      # stylesheet("foo") => <link href="/stylesheets/scaffold.css" media="screen" rel="stylesheet" type="text/css" />
      # 
      # distributed_site_domain is set to 'http://localhost:3001'
      # then, stylesheet("foo") will generate
      # <link href="http://localhost:3001/stylesheets/scaffold.css" media="screen" rel="stylesheet" type="text/css" />
      #
      def stylesheet(name)
        path = ""
        path = "#{app_config.mack.distributed_site_domain}" if app_config.mack.distributed_site_domain
        file_name = "#{name}.css" if !name.end_with?(".css")
        
        link = "<link href=\"#{path}/stylesheets/#{file_name}\" media=\"screen\" rel=\"stylesheet\" type=\"text/css\" />"
        return link
      end
      
    end # LinkHelpers
  end # ViewHelpers
end # Mack
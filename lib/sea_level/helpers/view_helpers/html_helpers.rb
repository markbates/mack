module Mack
  module ViewHelpers
    module HtmlHelpers
      
      # This is just an alias to 
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
      
      def b(options = {}, &block)
        content_tag(:b, options, &block)
      end
      
      # Builds an HTML tag.
      # 
      # Examples:
      #   content_tag(:b) {"hello"} # => <b>hello</b>
      #   content_tag("div", :class => :foo) {"hello world!"} # => <div class="foo">hello world!</div>
      def content_tag(tag, options = {}, content = nil, &block)
        if block_given?
          concat("<#{tag}#{build_options(options)}>", block.binding)
          yield
          concat("</#{tag}>", block.binding)
        else
           "<#{tag}#{build_options(options)}>#{content}</#{tag}>"
        end
      end
      
      # Builds an HTML tag with no content.
      # 
      # Examples:
      #   non_content_tag(:br) # => <br />
      #   non_content_tag(:hr, :width => "100%") # => <hr width="100%" />
      def non_content_tag(tag, options = {})
        "<#{tag}#{build_options(options)} />"
      end
      
      # Builds a HTML image tag.
      def img(image_src, options = {})
        non_content_tag(:img, {:src => image_src}.merge(options))
      end
      
      
      # Wraps an image tag with a link tag.
      # 
      # Examples:
      #   <%= link_image_to("/images/foo.jpg", "#" %> # => <a href="#"><img src="/images/foo.jpg"></a>
      def link_image_to(image_url, url, image_options = {}, html_options = {})
        link_to(img(image_url, image_options), url, html_options)
      end
      
      # Example:
      #   <%= rss_tag(posts_index_url(:format => :xml)) %>
      def rss_tag(url)
        "<link rel=\"alternate\" type=\"application/rss+xml\" title=\"RSS\" href=\"#{url}\">"
      end
      
      def form(options = {}, &block)
        options = {:method => "post"}.merge(options)
        if options[:id]
          options = {:class => options[:id]}.merge(options)
        end
        if options[:multipart]
          options = {:enctype => "multipart/form-data"}.merge(options)
          options.delete(:multipart)
        end
        content_tag(:form, options, &block)
      end
      
      private
      def build_options(options)
        opts = ""
        unless options.empty?
          opts = " " << options.join("%s=\"%s\"", " ")
        end
        opts
      end
      
    end # HtmlHelpers
  end # ViewHelpers
end # Mack
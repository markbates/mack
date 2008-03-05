module Mack
  module Utils
    # Useful utilities for dealing with HTML.
    class Html
      
      class << self
        
        # Used in views to create href links. It takes link_text, url, and a Hash that gets added
        # to the href as options.
        # 
        # Examples:
        #    Mack::Utils::Html.href("http://www.mackframework.com") # => <a href="http://www.mackframework.com">http://www.mackframework.com</a>
        #    Mack::Utils::Html.href("Mack", "http://www.mackframework.com") # => <a href="http://www.mackframework.com">Mack</a>
        #    Mack::Utils::Html.href("Mack", "http://www.mackframework.com", :target => "_blank") # => <a href="http://www.mackframework.com" target="_blank">Mack</a>
        #    Mack::Utils::Html.href("Mack", "http://www.mackframework.com", :target => "_blank", :rel => :nofollow) # => <a href="http://www.mackframework.com" target="_blank" rel="nofollow">Mack</a>
        # If you pass in :method as an option it will be a JavaScript form that will post to the specified link with the 
        # methd specified.
        #    Mack::Utils::Html.href("Mack", "http://www.mackframework.com", :method => :delete)
        # If you use the :method option you can also pass in a :confirm option. The :confirm option will generate a 
        # javascript confirmation window. If 'OK' is selected the the form will submit. If 'cancel' is selected, then
        # nothing will happen. This is extremely useful for 'delete' type of links.
        #    Mack::Utils::Html.href("Mack", "http://www.mackframework.com", :method => :delete, :confirm => "Are you sure?")
        def href(link_text, url = link_text, html_options = {})
          if html_options[:method]
            meth = nil
            confirm = nil

            meth = %{var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;var s = document.createElement('input'); s.setAttribute('type', 'hidden'); s.setAttribute('name', '_method'); s.setAttribute('value', '#{html_options[:method]}'); f.appendChild(s);f.submit()}
            html_options.delete(:method)

            if html_options[:confirm]
              confirm = %{if (confirm('#{html_options[:confirm]}'))}
              html_options.delete(:confirm)
            end

            html_options[:onclick] = (confirm ? (confirm + " { ") : "") << meth << (confirm ? (" } ") : "") << ";return false;"
          end

          html = "<a href=" << '"' << url
          html << '"'
          html << " " << html_options.join("%s=\"%s\"", " ") unless html_options.empty?
          html << ">" << link_text
          html << "</a>"
          html
        end
        
        alias_method :a, :href
        
        # Wraps the content_tag method.
        # 
        # Examples:
        #   Mack::Utils::Html.b("hello") # => <b>hello</b>
        #   Mack::Utils::Html.div("hello world!", :class => :foo)) # => <div class="foo">hello world!</div>
        def method_missing(sym, *args)
          ags = args.from_args
          
          tag = sym
          content = nil
          options = {}
          
          if ags.is_a?(Array)
            content = ags[0] if ags[0].is_a?(String)
            options = ags[1] if ags[1].is_a?(Hash)
          elsif ags.is_a?(String)
            content = ags
          elsif ags.is_a?(Hash)
            options = ags
          end
          
          content = yield if block_given?
          
          content_tag(tag, content, options)
        end
        
        # Builds an HTML tag.
        # 
        # Examples:
        #   content_tag(:b, "hello") # => <b>hello</b>
        #   content_tag("div", "hello world!", :class => :foo) # => <div class="foo">hello world!</div>
        def content_tag(tag, content, options = {})
          html = "<#{tag} #{options.join("%s=\"%s\"", " ")}>#{content}</#{tag}>"
        end
        
      end # self
      
    end # Html
  end # Utils
end # Mack
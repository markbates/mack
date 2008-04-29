module Mack
  module Utils
    # Useful utilities for dealing with HTML.
    class Html
      
      class << self
        
        # Used in views to create href links. It takes link_text, url, and a Hash that gets added
        # to the href as options.
        # 
        # Examples:
        #    Mack::Utils::Html.a("http://www.mackframework.com") # => <a href="http://www.mackframework.com">http://www.mackframework.com</a>
        #    Mack::Utils::Html.a("Mack", :href => "http://www.mackframework.com") # => <a href="http://www.mackframework.com">Mack</a>
        #    Mack::Utils::Html.a("Mack", :href => "http://www.mackframework.com", :target => "_blank") # => <a href="http://www.mackframework.com" target="_blank">Mack</a>
        #    Mack::Utils::Html.a("Mack", :href => "http://www.mackframework.com", :target => "_blank", :rel => :nofollow) # => <a href="http://www.mackframework.com" target="_blank" rel="nofollow">Mack</a>
        # If you pass in :method as an option it will be a JavaScript form that will post to the specified link with the 
        # methd specified.
        #    Mack::Utils::Html.a("Mack", :href => "http://www.mackframework.com", :method => :delete)
        # If you use the :method option you can also pass in a :confirm option. The :confirm option will generate a 
        # javascript confirmation window. If 'OK' is selected the the form will submit. If 'cancel' is selected, then
        # nothing will happen. This is extremely useful for 'delete' type of links.
        #    Mack::Utils::Html.a("Mack", :href => "http://www.mackframework.com", :method => :delete, :confirm => "Are you sure?")
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
          content_tag(:a, link_text, options)
        end
        
        alias_method :href, :a
        
        # A wrapper to generate an auto discovery tag so browsers no the page contains an RSS feed.
        # 
        # Example:
        #   <%= Mack::Utils::Html.rss(posts_index_url(:format => :xml)) %>
        def rss(url)
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
          content = yield
          content_tag(:form, content, options, &block)
        end
        
        # Wraps the content_tag method.
        # 
        # Examples:
        #   Mack::Utils::Html.b("hello") # => <b>hello</b>
        #   Mack::Utils::Html.div("hello world!", :class => :foo)) # => <div class="foo">hello world!</div>
        def method_missing(sym, *args, &block)
          ags = args.parse_splat_args
          
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
          
          if block_given?
            content = yield
            puts "content: #{content}"
            return content_tag(tag, content, options, &block)
          elsif content
            return content_tag(tag, content, options)
          else
            return non_content_tag(tag, options)
          end
        end
        
        # Builds an HTML tag.
        # 
        # Examples:
        #   content_tag(:b, "hello") # => <b>hello</b>
        #   content_tag("div", "hello world!", :class => :foo) # => <div class="foo">hello world!</div>
        def content_tag(tag, content, options = {}, &block)
          t = "<#{tag}#{build_options(options)}>#{content}</#{tag}>"
          if block_given?
            return Erubis::Eruby.new(t).result(block.binding)
          end
          t
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
        
        private
        def build_options(options)
          opts = ""
          unless options.empty?
            opts = " " << options.join("%s=\"%s\"", " ")
          end
          opts
        end
        
      end # self
      
    end # Html
  end # Utils
end # Mack
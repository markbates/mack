module Mack
  module ViewHelpers
    module HtmlHelpers
      
      # This is just an alias to Mack::Utils::Html.
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
        Mack::Utils::Html.href(link_text, url, html_options)
      end
      
      # A wrapper method for views that calls out to Mack::Utils::Html.
      # 
      # Examples:
      #   <%= html.b("hello") %> # => <b>hello</b>
      def html
        Mack::Utils::Html
      end
      
      def rss_tag(url)
        "<link rel=\"alternate\" type=\"application/rss+xml\" title=\"RSS\" href=\"#{url}\">"
      end
      
    end # HtmlHelpers
  end # ViewHelpers
end # Mack
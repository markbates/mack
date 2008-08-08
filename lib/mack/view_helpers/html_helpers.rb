module Mack
  module ViewHelpers # :nodoc:
    module HtmlHelpers
      
      # Builds an HTML tag.
      # 
      # Examples:
      #   content_tag(:b) {"hello"} # => <b>hello</b>
      #   content_tag("div", :class => :foo) {"hello world!"} # => <div class="foo">hello world!</div>
      def content_tag(tag, options = {}, content = nil, &block)
        if block_given?
          concat("<#{tag}#{build_options(options)}>\n", block.binding)
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
      
      # Example:
      #   <%= rss_tag(posts_index_url(:format => :xml)) %>
      def rss_tag(url)
        "<link rel=\"alternate\" type=\"application/rss+xml\" title=\"RSS\" href=\"#{url}\">"
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
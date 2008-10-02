module Mack
  module ViewHelpers # :nodoc:
    module HtmlHelpers
      
      include Mack::AssetHelpersCommon
      
      # Builds an HTML tag.
      # 
      # Examples:
      #   content_tag(:b) {"hello"} # => <b>hello</b>
      #   content_tag("div", :class => :foo) {"hello world!"} # => <div class="foo">hello world!</div>
      def content_tag(tag, options = {}, content = nil, &block)
        if block_given?
          concat("<#{tag}#{build_options(options)}>\n", block.binding)
          yield
          concat("\n</#{tag}>", block.binding)
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
        image_src = "#{get_resource_root(image_src)}#{image_src}?#{configatron.mack.assets.stamp}"
        non_content_tag(:img, {:src => image_src}.merge(options))
      end
      
      # Example:
      #   <%= rss_tag(posts_index_url(:format => :xml)) %>
      def rss_tag(url)
        "<link rel=\"alternate\" type=\"application/rss+xml\" title=\"RSS\" href=\"#{url}\">"
      end
      
      def google_analytics(id)
        %{
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
var pageTracker = _gat._getTracker("#{id}");
pageTracker._trackPageview();
</script>}.strip
      end
      
      private
      def build_options(options)
        if options[:disabled]
          options[:disabled] = :disabled
        end
        opts = ""
        unless options.empty?
          opts = " " << options.join("%s=\"%s\"", " ")
        end
        opts
      end
      
      def get_resource_root(resource)
        path = ""
        path = "#{configatron.mack.distributed.site_domain}" unless configatron.mack.distributed.site_domain.nil?
        path = Mack::AssetHelpers.instance.asset_hosts(resource) if path.empty?
        return path
      end
      
      
    end # HtmlHelpers
  end # ViewHelpers
end # Mack
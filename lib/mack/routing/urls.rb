module Mack
  module Routes
    # This module is the repository for named_routes. See Mack::Routes::RouteMap for more information.
    module Urls
    
      # Takes a url pattern and merges it with the options to hopefully produce a well formed url.
      # Query string parameters will get escaped.
      # 
      # Example:
      #   url_for_pattern("/:controller/:action/:id", {:controller => :blog, :action => :show, :id => 1})
      #     # => "/blog/show/1
      #   url_for_pattern("/:controller/:action/:id", {:controller => :blog, :action => :show})
      #     # => "/blog/show/:id"
      #   url_for_pattern("/blog/:id", {:id => 1})
      #     # => "/blog/1
      #   url_for_pattern("/blog/:id", {:id => 1, :n_id => 2})
      #     # => "/blog/1?n_id=2
      def url_for_pattern(url, options = {})
        u = url.dup
        u = "/" if url.blank?
        unused_params = []
        format = nil
        options.each_pair do |k, v|
          unless k.to_sym == :format
            vp = Rack::Utils.escape(v.to_param)
            if u.gsub!(":#{k}", vp).nil?
              unused_params << "#{Rack::Utils.escape(k)}=#{vp}"
            end
          else
            format = v
          end
        end
        if format
          u << ".#{format}"
        end
        unless unused_params.empty?
          u << "?" << unused_params.sort.join("&")
        end
        u
      end
    
      # Builds a simple HTML page to be rendered when a redirect occurs.
      # Hopefully no one sees the HTML, but in case the browser won't do the
      # redirect it's nice to let people know what's happening.
      def redirect_html(original_path, new_path, status)
        %{
          <!DOCTYPE HTML PUBLIC 
              "-//IETF//DTD HTML 2.0//EN"> 
          <html>
            <head> 
              <title>#{status} Found</title> 
            </head>
            <body> 
              <h1>Found</h1> 
               <p>The document has moved <a href="#{new_path}">here</a>.</p> 
            </body>
          </html>
        }
      end
      
    end # Urls
  end # Routes
end # Mack 
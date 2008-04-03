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
      
      # Retrieves a distributed route from a DRb server.
      # 
      # Example:
      #   droute_url(:app_1, :home_page_url)
      #   droute_url(:registration_app, :signup_url, {:from => :google})
      def droute_url(app_name, route_name, options = {})
        if app_config.mack.use_distributed_routes
          d_urls = Mack::Distributed::Routes::Urls.get(app_name)
          # return d_urls.send(route_name, options)
          # ivar_cache("droute_url_hash") do
          #   {}
          # end
          # d_urls = @droute_url_hash[app_name.to_sym]
          # if d_urls.nil?
          #   d_urls = Mack::Distributed::Routes::UrlCache.get(app_name.to_sym)
          #   @droute_url_hash[app_name.to_sym] = d_urls
          #   if d_urls.nil?
          #     raise Mack::Distributed::Errors::UnknownApplication.new(app_name)
          #   end
          # end
          route_name = route_name.to_s
          if route_name.match(/_url$/)
            unless route_name.match(/_distributed_url$/)
              route_name.gsub!("_url", "_distributed_url")
            end
          else
            route_name << "_distributed_url"
          end
          raise Mack::Distributed::Errors::UnknownRouteName.new(app_name, route_name) unless d_urls.respond_to?(route_name)
          return d_urls.run(route_name, options)
          # if d_urls.run.respond_to?(route_name)
          #   return d_urls.run.send(route_name, options)
          # else
          #   raise Mack::Distributed::Errors::UnknownRouteName.new(app_name, route_name)
          # end
        else
          return nil
        end
      end # droute_url
    
    end # Urls
  end # Routes
end # Mack 
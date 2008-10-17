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
        host_options = {:host => options[:host], :port => options[:port], :scheme => options[:scheme]}
        options - [:host, :port, :scheme]
        if host_options[:host]
          hu = host_options[:host].dup
          options.each_pair do |k, v|
            vp = Rack::Utils.escape(v.to_param)
            unless hu.gsub!(":#{k}", vp).nil?
              options - [k.to_sym]
            end
          end
          host_options[:host] = hu
        end
        options.each_pair do |k, v|
          unless k.to_sym == :format
            if u.match(/\*#{k}/)
              vp = [v].flatten.collect {|c| Rack::Utils.escape(c.to_param)}
              if u.gsub!("*#{k}", File.join(vp)).nil?
                unused_params << "#{Rack::Utils.escape(k)}=#{vp}"
              end
            else
              vp = Rack::Utils.escape(v.to_param)
              if u.gsub!(":#{k}", vp).nil?
                unused_params << "#{Rack::Utils.escape(k)}=#{vp}"
              end
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
        File.join(build_full_host_from_options(host_options), u)
        # u
      end
    
      # Builds a simple HTML page to be rendered when a redirect occurs.
      # Hopefully no one sees the HTML, but in case the browser won't do the
      # redirect it's nice to let people know what's happening.
      def redirect_html(original_path, new_path, status) # :nodoc:
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
      
      def self.create_method(sym, &block) # :nodoc:
        define_method(sym, &block)
      end
      
      private
      def build_full_host_from_options(options = {})
        scheme = options[:scheme]
        host = options[:host]
        port = options[:port]
        return '' if host.blank? && scheme.blank? && port.nil?
        if @request
          scheme = @request.scheme if scheme.nil?
          port = @request.port if port.nil?
          host = @request.host if host.nil?
        end
        port = 80 if port.nil?
        port = case port.to_i
        when 80, 443
        else
          ":#{port}"
        end
        return "#{(scheme || 'http').downcase}://#{host.downcase}#{port}"
      end
      
    end # Urls
  end # Routes
end # Mack 
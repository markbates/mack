require 'net/http'
module Mack
  module Rendering
    # Used when someone calls render(:url => "http://www.mackframework.com")
    class Url < Base
      
      def render
        options = {:method => :get, :domain => app_config.mack.site_domain, :raise_exception => false}.merge(self.options)
        case options[:method]
        when :get
          do_render_url(options) do |uri, options|
            unless options[:parameters].empty?
              uri = uri.to_s
              uri << "?"
              options[:parameters].each_pair do |k,v|
                uri << URI.encode(k.to_s)
                uri << "="
                uri << URI.encode(v.to_s)
                uri << "&"
              end
              uri.gsub!(/&$/, "")
              uri = URI.parse(uri)
            end
            Net::HTTP.get_response(uri)
          end
        when :post
          do_render_url(options) do |uri, options|
            Net::HTTP.post_form(uri, options[:parameters] || {})
          end
        else
          raise Mack::Errors::UnsupportRenderUrlMethodType.new(options[:method])
        end
      end
      
      private
      def do_render_url(options)
        Timeout::timeout(app_config.mack.render_url_timeout || 5) do
          url = options[:url]
          unless url.match(/^[a-zA-Z]+:\/\//)
            url = File.join(options[:domain], options[:url])
          end
          uri = URI.parse(url)
          response = yield uri, options
          if response.code == "200"
            return response.body
          else
            if options[:raise_exception]
              raise Mack::Errors::UnsuccessfulRenderUrl.new(uri, response)
            else
              return ""
            end
          end
        end
      end
      
    end
  end
end
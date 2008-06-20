require File.join(File.dirname(__FILE__), 'base')
module Mack
  module Rendering # :nodoc:
    module Type # :nodoc:
      # This class will render the contents of a url.
      # 
      # Examples:
      # This is considered a 'remote' request and will be made using GET.
      #   <%= render(:url, "http://www.mackframework.com") %>
      # This is considered a 'remote' request and will be made using POST.
      #   <%= render(:url, "http://www.mackframework.com", :method => :post) %>
      # This is considered a 'remote' request and will be made using GET, and will have query string parameters.
      #   <%= render(:url, "http://www.mackframework.com", :parameters => {:name => "mark"}) %> # http://www.mackframework.com?name=mark
      # This is considered a 'remote' request and will be made using POST, and will have form parameters.
      #   <%= render(:url, "http://www.mackframework.com", :method => :post, :parameters => {:name => "mark"}) %>
      # 
      # 'Local' requests can also be made:
      # This is considered a 'local' request and will be made using GET.
      #   <%= render(:url, "/users") %>
      # This is considered a 'local' request and will be made using POST.
      #   <%= render(:url, "/users", :method => :post) %>
      # This is considered a 'local' request and will be made using GET, and will have query string parameters.
      #   <%= render(:url, "/users", :parameters => {:name => "mark"}) %> # /users?name=mark
      # This is considered a 'local' request and will be made using POST, and will have form parameters.
      #   <%= render(:url, "/users", :method => :post, :parameters => {:name => "mark"}) %>
      class Url < Mack::Rendering::Type::Base
        
        # No layouts should be used with this Mack::Rendering::Type
        def allow_layout?
          false
        end
        
        # Retrieves the contents of the url using either GET or POST, passing along any specified parameters.
        def render
          options = {:method => :get, :raise_exception => false}.merge(self.options)
          url = self.render_value
          remote = url.match(/^[a-zA-Z]+:\/\//)
          case options[:method]
          when :get
            if remote
              do_render_remote_url(url_with_query(url, options[:parameters]), options) do |uri, options|
                Net::HTTP.get_response(uri)
              end
            else
              do_render_local_url(url, options) do |url, options|
                Rack::MockRequest.new(self.app_for_rendering).get(url, options)
              end
            end
          when :post
            if remote
              do_render_remote_url(url, options) do |uri, options|
                Net::HTTP.post_form(uri, options[:parameters] || {})
              end
            else
              do_render_local_url(url, options) do |url, options|
                Rack::MockRequest.new(self.app_for_rendering).post(url, options)
              end
            end
          else
            raise Mack::Errors::UnsupportRenderUrlMethodType.new(options[:method])
          end
        end

        private
        def do_render_remote_url(url, options)
          Timeout::timeout(app_config.mack.render_url_timeout || 5) do
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

        def do_render_local_url(url, options)
          Timeout::timeout(app_config.mack.render_url_timeout || 5) do
            cooks = {}
            self.view_template.cookies.all.each do |c,v|
              cooks[c] = v[:value]
            end
            request = self.view_template.request
            # Mack.logger.debug "ORIGINAL REQUEST: #{request.env.inspect}"
            env = request.env.dup
            env - ["rack.input", "rack.errors", "PATH_INFO", "REQUEST_PATH", "REQUEST_URI", "REQUEST_METHOD"]
            env["rack.request.query_hash"] = options[:parameters] || {}
            env["HTTP_COOKIE"] = "#{app_config.mack.session_id}=#{request.session.id};" if env["HTTP_COOKIE"].nil?
            options = env.merge(options)
            # Mack.logger.debug "NEW OPTIONS: #{options.inspect}"
            # Mack.logger.debug "url: #{url}"
            response = yield url, options
            if response.successful?
              return response.body
            else
              if options[:raise_exception]
                raise Mack::Errors::UnsuccessfulRenderUrl.new(url, response)
              else
                return ""
              end
            end
          end
        end

        def url_with_query(url, parameters = {})
          unless (parameters || {}).empty?
            url = url.to_s.dup
            url << "?"
            url << parameters.to_params(true)
          end
          url
        end
        
      end
    end
  end
end
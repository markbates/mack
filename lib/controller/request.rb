module Mack
  
  class Request < Rack::Request
    
    class Parameters < Hash # :nodoc:
      alias_method :old_hash, :[]
      def [](key)
        data = old_hash(key.to_sym) || old_hash(key.to_s)
        data = data.to_s if data.is_a?(Symbol)
        return data
      end
    end
    
    
    def initialize(env) # :nodoc:
      super(env)
      @mack_params = Mack::Request::Parameters.new
      parse_params(rack_params)
    end
    
    alias_method :rack_params, :params # :nodoc:
        
    # Merges another Hash with the parameters for this request.
    def merge_params(opts = {})
      parse_params(opts)
    end
    
    # Gives access to the session. See Mack::Session for more information.
    attr_accessor :session 
    
    # Examples:
    #  http://example.org
    #  https://example.org
    #  http://example.org:8080
    def full_host
      u = self.scheme.dup
      u << "://"
      u << self.host.dup
      unless self.port == 80 || self.port == 443
        u << ":#{self.port}"
      end
      u
    end
    
    # Examples:
    #  http://example.org:80
    #  https://example.org:443
    #  http://example.org:8080
    def full_host_with_port
      full_host << ":#{self.port}"
    end
    
    # Gives access to the request parameters. This includes 'get' parameters, 'post' parameters
    # as well as parameters from the routing process. The parameter will also be 'unescaped'
    # when it is returned.
    # 
    # Example:
    #   uri: '/users/1?foo=bar'
    #   route: '/users/:id' => {:controller => 'users', :action => 'show'}
    #   parameters: {:controller => 'users', :action => 'show', :id => 1, :foo => "bar"}
    def params
      @mack_params
    end
    
    alias_method :all_params, :params
    
    # Returns a Mack::Request::UploadedFile object.
    def file(key)
      ivar_cache("file_#{key}") do
        Mack::Request::UploadedFile.new(params[key] ||= {})
      end
    end
    
    private
    def parse_params(ps)
      ps.each_pair do |k, v|
        if k.to_s.match(/.+\[.+\]/)
          nv = k.to_s.match(/.+\[(.+)\]/).captures.first
          nk = k.to_s.match(/(.+)\[.+\]/).captures.first
          @mack_params[nk.to_sym] = {} if @mack_params[nk.to_sym].nil?
          @mack_params[nk.to_sym].merge!(nv.to_sym => v.to_s.uri_unescape)
        else
          v = v.uri_unescape if v.is_a?(String)
          @mack_params[k.to_sym] = v#.to_s.uri_unescape
        end
      end
    end
    
  end
end
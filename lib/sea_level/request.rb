module Mack
  class Request < Rack::Request
    
    def initialize(env) # :nodoc:
      super(env)
      @mack_params = {}
      parse_params(rack_params)
    end
    
    alias_method :rack_params, :params # :nodoc:
    
    # Returns all parameters associated with this request.
    def all_params
      @mack_params
    end
    
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
    def params(key)
      p = (@mack_params[key.to_sym] || @mack_params[key.to_s])
      unless p.nil?
        p = p.to_s if p.is_a?(Symbol)
        if p.is_a?(String)
          p = p.to_s.uri_unescape
        elsif p.is_a?(Hash)
          p.each_pair {|k,v| p[k] = v.to_s.uri_unescape}
        end
      end
      p
    end
    
    private
    def parse_params(ps)
      ps.each_pair do |k, v|
        if k.to_s.match(/.+\[.+\]/)
          nv = k.to_s.match(/.+\[(.+)\]/).captures.first
          nk = k.to_s.match(/(.+)\[.+\]/).captures.first
          @mack_params[nk.to_sym] = {} if @mack_params[nk.to_sym].nil?
          @mack_params[nk.to_sym].merge!(nv.to_sym => v)
        else
          @mack_params[k.to_sym] = v
        end
      end
    end
    
  end
end
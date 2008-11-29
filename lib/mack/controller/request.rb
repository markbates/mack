module Mack
  
  class Request < Rack::Request
    
    autoload :DateTimeParameter, File.join_from_here('request', 'date_time_parameter')
    autoload :Parameters, File.join_from_here('request', 'parameters')
    
    def initialize(env) # :nodoc:
      super(env)
      @mack_params = Mack::Request::Parameters.new
      parse_params(rack_params)
    end
    
    alias_instance_method :params, :rack_params # :nodoc:
        
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
    
    # Returns all the subdomains as an array, so ["dev", "www"] would be returned for 
    # "dev.www.mackframework.com". You can specify a different tld_length, such as 2 
    # to catch ["www"] instead of ["www", "mackframework"] in "www.mackframework.co.uk".
    # 
    # Thanks Ruby on Rails for this.
    def subdomains(tld_length = 1)
      return [] unless named_host?(host)
      parts = host.split('.')
      parts[0..-(tld_length+2)]
    end
    
    # Examples:
    #  http://example.org:80
    #  https://example.org:443
    #  http://example.org:8080
    def full_host_with_port
      unless full_host.match(/:#{self.port}/)
        return full_host + ":#{self.port}"
      end
      return full_host
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
    
    def params=(p) # :nodoc:
      @mack_params = Mack::Request::Parameters.new
      parse_params(p)
    end
    
    alias_instance_method :params, :all_params
    
    # Returns a Mack::Request::UploadedFile object.
    def file(key)
      ivar_cache("file_#{key}") do
        Mack::Request::UploadedFile.new(params[key] ||= {})
      end
    end
    
    private
    def named_host?(host)
      !(host.nil? || /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/.match(host))
    end
    
    def parse_params(ps)
      
      # look for date time selects:
      dts = ps.select {|k,v| k.to_s.match(/\(.+\)/)}
      unless dts.empty?
        dtsh = {}
        dts.each do |k,v|
          # convert dilbert[created_at(year)] # => dilbert[created_at]
          p_name = k.gsub(/\(.+\)/, '')
          # get 'year'
          sub_p_name = k.match(/\((.+)\)/).captures.first.to_s
          # create a new DateTimeParameter if one doesn't exist for this parameter yet
          dtsh[p_name] = DateTimeParameter.new if dtsh[p_name].nil?
          # set the accessor for this part of the select
          dtsh[p_name].add(sub_p_name, v)
        end
        # Add the final DateTimeParameter's back onto the request stack.
        dtsh.each do |k,v|
          ps[k] = v.to_time
        end
      end
      
      ps.reject {|k,v| k.to_s.match(/\(.+\)/)}.each do |k,v|
        if k.to_s.match(/.+\[.+\]/)
          nv = k.to_s.match(/.+\[(.+)\]/).captures.first
          nk = k.to_s.match(/(.+)\[.+\]/).captures.first
          nk.downcase!
          nv.downcase!
          @mack_params[nk.to_sym] = {} if @mack_params[nk.to_sym].nil?
          v = v.uri_unescape if v.is_a?(String)
          @mack_params[nk.to_sym].merge!(nv.to_sym => v)
        else
          v = v.uri_unescape if v.is_a?(String)
          @mack_params[k.to_sym] = v#.to_s.uri_unescape
        end
      end
    end
    
  end # Request
end # Mack
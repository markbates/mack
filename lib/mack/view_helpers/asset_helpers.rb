module Mack
  class AssetHelpers # :nodoc:
    include Singleton
    
    # 
    # Set the asset hosts for this app.  It supports the following format:
    # - plain string: the string literal will be considered as the asset hosts (e.g. 'http://assets.foo.com')
    # - formatted string: to support asset host distribution (e.g. 'http://asset%d.foo.com')
    # - a proc object: to support custom asset hosts generation (e.g. Proc.new { |source| 'assets.foo.com' }
    #
    # The max number of distribution can be set from configatron.mack.assets.max_distribution.
    # The default value is 4
    #
    def asset_hosts=(host)
      @hosts = host
    end
    
    # 
    # Return the max number of asset hosts distribution
    #
    def max_distribution
      return configatron.mack.assets.max_distribution
    end
    
    #
    # Return the asset hosts for this application.
    #
    def asset_hosts(source = '')
      ret_val = ''
      
      # if no explicit asset_host setting, then use the one defined in configatron (if exists)
      host = @hosts || configatron.mack.assets.hosts
      host = '' if host.nil?
      
      if host.kind_of?(Proc)
        ret_val = host.call(source)
      else
        ret_val = sprintf(host, rand(max_distribution))
      end
      return ret_val
    end
    
    #
    # Clear previously set configuration for asset hosts
    #
    def reset!
      @hosts = nil
    end
  end
end

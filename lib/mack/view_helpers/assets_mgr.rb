module Mack
  #
  # Like the name suggests, this object will manage
  # assets (i.e. scripts and stylesheets) used in a mack application.
  # Developer will be able to use the manager to create
  # assets groups, and refer them later in the erb file.
  # <br>
  # There's a convenient method available, called assets_mgr.
  # Application should use that method to create new bundle, and to access
  # defined bundles.
  # <br>
  # Example:
  #   # This will create new bundle called foo
  #   assets_mgr.foo do |a|
  #     a.add_js "foo"
  #     a.add_css "bar"
  #   end
  #   
  # Note that nested group is not supported.
  #
  class AssetsManager
    include Singleton
  
    def initialize # :nodoc:
      @group_hash = {}
      @javascripts = nil
      @stylesheets = nil
    end
    
    #
    # Clear the defined assets
    #
    def reset!
      @group_hash.clear
    end
  
    def method_missing(sym, *args, &block) # :nodoc:
      @group_hash[sym] ||= {:javascripts => [], :stylesheets => []}
      @javascripts = @group_hash[sym][:javascripts]
      @stylesheets = @group_hash[sym][:stylesheets]
      yield(self) if block_given?
    end
    
    # 
    # return all groups defined for both javascript and stylesheets
    #
    def groups
      return @group_hash.keys
    end
    
    # 
    # Return all groups defined by specified asset type
    #
    # <i>Params:</i>
    #   type -- asset type (can be either :javascript or :stylesheet)
    def groups_by_asset_type(type)
      arr = []
      groups.each do |group|
        arr << group if @group_hash[group.to_sym] and @group_hash[group.to_sym][type.to_sym]
      end
      return arr
    end
    
    #
    # Return supported asset types
    #
    def asset_types
      return [:javascripts, :stylesheets]
    end
  
    #
    # Get all javascript asset files defined for the specified group/bundle
    #
    def javascripts(group)
      return nil if !@group_hash.has_key?(group.to_sym)
      return @group_hash[group.to_sym][:javascripts]
    end
    
    #
    # Get all stylesheet asset files defined for the specified group/bundle
    #
    def stylesheets(group)
      return nil if !@group_hash.has_key?(group.to_sym)
      return @group_hash[group.to_sym][:stylesheets]
    end
      
    #
    # Add javascript file(s) to the group/bundle
    #
    def add_js(data)
      return add_data(data, 'javascripts', '.js')
    end
  
    #
    # Add stylesheet file(s) to the group/bundle
    #
    def add_css(data)
      return add_data(data, 'stylesheets', '.css')
    end

    def display # :nodoc:
      pp @group_hash
    end
  
    private
    def add_data(data, type, file_type)
      data = [data].flatten
      data.each do |elt|
        elt = elt.to_s
        elt += file_type if !elt.end_with?(file_type)
        eval("@#{type} << elt")
      end
      return true
    end
  end
end

module Kernel
  #
  # Return the instance of the AssetManager class.
  #
  def assets_mgr
    return Mack::AssetsManager.instance
  end
end

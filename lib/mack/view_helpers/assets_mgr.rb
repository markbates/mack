module Mack
  class AssetsManager
    include Singleton
  
    def initialize
      @group_hash = {}
      @javascripts = nil
      @stylesheets = nil
    end
    
    def reset!
      @group_hash.clear
    end
  
    def method_missing(sym, *args, &block)
      @group_hash[sym] ||= {:javascripts => [], :stylesheets => []}
      @javascripts = @group_hash[sym][:javascripts]
      @stylesheets = @group_hash[sym][:stylesheets]
      yield(self) if block_given?
    end
    
    def groups
      return @group_hash.keys
    end
    
    def groups_by_asset_type(type)
      arr = []
      groups.each do |group|
        arr << group if @group_hash[group.to_sym] and @group_hash[group.to_sym][type.to_sym]
      end
      return arr
    end
    
    def content_types
      return [:javascripts, :stylesheets]
    end
  
    def javascripts(group)
      return nil if !@group_hash.has_key?(group.to_sym)
      return @group_hash[group.to_sym][:javascripts]
    end
  
    def stylesheets(group)
      return nil if !@group_hash.has_key?(group.to_sym)
      return @group_hash[group.to_sym][:stylesheets]
    end
      
    def add_js(data)
      return add_data(data, 'javascripts', '.js')
    end
  
    def add_css(data)
      return add_data(data, 'stylesheets', '.css')
    end
  
    def display
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
  def assets
    return Mack::AssetsManager.instance
  end
end

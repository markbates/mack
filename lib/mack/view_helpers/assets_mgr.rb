module Mack
  module Assets
    class Bundle # :nodoc:
      attr_accessor :data
      attr_accessor :name

      def initialize(bundle_name)
        self.name = bundle_name
        self.data = {:javascripts => [], :stylesheets => []}
      end

      def assets(asset_type)
        self.data[asset_type]
      end

      #
      # Add javascript file(s) to the group/bundle
      #
      def add_js(files)
        return add_data(files, :javascripts, '.js')
      end
      alias_method :javascript, :add_js
      
      def remove_js(files)
        files = [files].flatten
        self.data[:javascripts] -= files
      end

      #
      # Add stylesheet file(s) to the group/bundle
      #
      def add_css(files)
        return add_data(files, :stylesheets, '.css')
      end
      alias_method :stylesheet, :add_css

      def remove_css(files)
        files = [files].flatten
        self.data[:stylesheets] -= files
      end

      def reset!(type = :all)
        if type == :all
          self.data.keys.each do |key|
            self.data[key].clear
          end
        else
          self.data[type].clear if self.data[type]
        end
      end

      private
      def add_data(data, type, file_type)
        data = [data].flatten
        data.each do |elt|
          elt = elt.to_s
          elt += file_type if !elt.end_with?(file_type)
          self.data[type.to_sym] << elt
        end
        return true
      end

    end
  
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
    class Manager
      include Singleton

      def initialize # :nodoc:
        @bundles = {}
      end

      #
      # Clear the defined assets
      #
      def reset!
        @bundles.clear
      end

      def method_missing(sym, *args, &block) # :nodoc:
        if @bundles.has_key?(sym.to_s)
          bundle = @bundles[sym.to_s]
        else
          bundle = Mack::Assets::Bundle.new(sym.to_s)
          @bundles[sym.to_s] = bundle
        end
        if block_given?
          yield bundle
        end
        return bundle
      end

      # 
      # return all groups defined for both javascript and stylesheets
      #
      def groups
        @bundles.keys
      end

      # 
      # Return all groups defined by specified asset type
      #
      # <i>Params:</i>
      #   type -- asset type (can be either :javascript or :stylesheet)
      def groups_by_asset_type(type)
        arr = []
        groups.each do |group|
          arr << group if !@bundles[group.to_s].assets(type.to_sym).empty?
        end
        return arr
      end
      
      def has_group?(group, asset_type = nil)
        if asset_type
          return groups_by_asset_type(asset_type).include?group.to_s
        else
          return groups.include?(group)
        end
      end

      def assets(asset_type, group)
        return nil if !@bundles.has_key?(group.to_s)
        return @bundles[group.to_s].assets(asset_type)
      end

      def javascripts(group)
        return assets(:javascripts, group)
      end

      def stylesheets(group)
        return assets(:stylesheets, group)
      end
    end
    
  end
end

  

module Kernel
  #
  # Return the instance of the AssetManager class.
  #
  def assets_mgr
    return Mack::Assets::Manager.instance
  end
end

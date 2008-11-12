module Kernel
  
  def init_message(message) # :nodoc:
    message = "Initializing '#{message}' ..."
    if Mack.methods.include?('logger')
      Mack.logger.debug(message) unless configatron.mack.log.disable_initialization_logging
    else
      puts message
    end
  end
  
  # Returns Mack::Portlets::Manager
  def require_portlets
    yield Mack::Portlet::Manager.instance
  end
  
  # Returns an Array of gems required by the Mack::Portlets::Manager
  def required_portlets_list
    Mack::Portlet::Manager.instance.required_portlet_list
  end
  
  #
  # Return the instance of the AssetManager class.
  #
  def assets_mgr
    return Mack::Assets::Manager.instance
  end
  
  # Returns Mack::Utils::GemManager
  def require_gems
    yield Mack::Utils::GemManager.instance
  end
  
  # Returns an Array of gems required by the Mack::Utils::GemManager
  def required_gem_list
    Mack::Utils::GemManager.instance.required_gem_list
  end
  
  # Aliases the deprecated method to the new method and logs a warning.
  def alias_deprecated_method(deprecated_method, new_method, version_deprecrated = nil, version_to_be_removed = nil)
    eval %{
      def #{deprecated_method}(*args)
        deprecate_method(:#{deprecated_method}, :#{new_method}, "#{version_deprecrated}", "#{version_to_be_removed}")
        #{new_method}(*args)
      end
    }
  end
  
  # Logs a warning that a method has been deprecated. Warnings will only get logged once.
  def deprecate_method(deprecated_method, new_method = nil, version_deprecrated = nil, version_to_be_removed = nil)
    message = "DEPRECATED: '#{deprecated_method}'."
    if new_method
      message << " Please use '#{new_method}' instead."
    end
    if version_deprecrated
      message << " Deprecated in version: '#{version_deprecrated}'."
      if version_to_be_removed.nil?
        version_to_be_removed = ">=#{version_deprecrated.succ}"
      end
    end
    if version_to_be_removed
      message << " To be removed in version: '#{version_to_be_removed}'."
    end
    unless Kernel::DeprecatedRegistryList.registered_items.include?(message)
      Mack.logger.warn(message)
      Kernel::DeprecatedRegistryList.add(message)
    end
  end
  
  unless Module.const_defined?('GEM_MOD')
    Module.const_set('GEM_MOD', 1)
    
    alias_instance_method :gem, :old_gem
    
    def gem(gem_name, *version_requirements)
      # vendor_path = File.join(Mack.root, 'vendor')
      # gem_path = File.join(vendor_path, 'gems')
      # add_gem_path(File.join(Mack.root, 'vendor', 'gems'))
      Gem.set_paths(File.join(Mack.root, 'vendor', 'gems'))
      
      # try to normalize the version requirement string
      ver = version_requirements.to_s.strip
      ver = "> 0.0.0" if ver == nil or ver.empty?
      # if the version string starts with number, then prepend = to it (since the developer wants an exact match)
      ver = "= " + ver if ver[0,1] != '=' and ver[0,1] != '>' and ver[0,1] != '<' and ver[0,1] != '~'
      
      num = ver.match(/\d.+/).to_s
      op  = ver.delete(num).strip
      op  += "=" if op == '='
      
      op = '>=' if op == '~>'
      
      found_local_gem = false
      
      dirs = []
      Gem.path.each do |p|
        dirs << Dir.glob(File.join(p, "#{gem_name}*"))
      end
      dirs.flatten!
      dirs.uniq!
      
      dirs.each_with_index do |file, i|
        file = File.basename(file)
        # all frozen gem has the pattern [gem_name]-[version]
        next if !file.include?'-'
  
        # make sure we're not loading gem with almost the same name, e.g. "#{gem_name}-foo_bar-0.89.1"
        file_gem_name = file.match(/\D*-/).to_s
        next if !file.starts_with?(file_gem_name)
        
        # find the version number from the file name
        file_ver = file.match(/\d.+/).to_s
        
        # generate number comparison string that we can evaluate, to make sure that we
        # pick the correct gem based on the requested version requirements
        comparison = "'#{file_ver}' #{op} '#{num}'"  # e.g.: "'0.8.0' > '0.0.0'"
        
        # if we find the match (i.e. the comparison string checks out) then
        # read the frozen spec file in that directory (so we can see what the require path is)
        # and prepend the new require path(s) to the global search path.
        # If we didn't find it, then continue to look (obviously)
        if eval(comparison)           
          spec_file = File.join(file, 'spec.yaml')
          
          if File.exists?(spec_file)
            spec = YAML.load(File.read(spec_file))
          else
            spec = nil
          end
          
          if spec and spec.require_path
            spec.require_path.each { |rp| $:.insert(0, File.expand_path(File.join(file, rp))) }
          else
            $:.insert(0, File.expand_path(file))
          end

          found_local_gem = true
          break
        end
      end 
    
      # if After going through the vendor/gems folder and we still didn't find
      # any frozen gem that matched the criteria, then call the system's gem loader
      if !found_local_gem
        # puts "Loading installed gem: #{gem_name}"
        old_gem(gem_name, *version_requirements)
      end
    end
  end
    
  private
  class DeprecatedRegistryList < Mack::Utils::RegistryList # :nodoc:
  end
  
end
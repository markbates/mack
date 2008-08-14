module Kernel
  
  # Returns Mack::Utils::GemManager
  def require_gems
    yield Mack::Utils::GemManager.instance
  end
  
  def alias_deprecated_method(deprecated_method, new_method, version_deprecrated = nil, version_to_be_removed = nil) # :nodoc:
    message = "DEPRECATED: '#{deprecated_method}'. Please use '#{new_method}' instead."
    if version_deprecrated
      message << " Deprecated in version: '#{version_deprecrated}'."
      if version_to_be_removed.nil?
        version_to_be_removed = ">=#{version_deprecrated.succ}"
      end
    end
    if version_to_be_removed
      message << " To be removed in version: '#{version_to_be_removed}'."
    end
    eval %{
      def #{deprecated_method}(*args)
        Mack.logger.warn("#{message}")
        #{new_method}(*args)
      end
    }
  end
  
end
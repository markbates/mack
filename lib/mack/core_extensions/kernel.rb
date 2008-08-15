module Kernel
  
  # Returns Mack::Utils::GemManager
  def require_gems
    yield Mack::Utils::GemManager.instance
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
  
  private
  class DeprecatedRegistryList < Mack::Utils::RegistryList # :nodoc:
  end
  
end
module Kernel
  
  # Returns Mack::Utils::GemManager
  def require_gems
    yield Mack::Utils::GemManager.instance
  end
  
end
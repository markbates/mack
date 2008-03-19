module Kernel
  
  def _encrypt(value, worker = :default)
    Mack::Utils::Crypt::Keeper.instance.worker(worker).encrypt(value)
  end
  
  def _decrypt(value, worker = :default)
    Mack::Utils::Crypt::Keeper.instance.worker(worker).decrypt(value)
  end
  
end
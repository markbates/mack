module Kernel
  
  # A helper method that calls Mack::Utils::Crypt::Keeper with the specified worker
  # and calls the encrypt method on that worker.
  def _encrypt(value, worker = :default)
    Mack::Utils::Crypt::Keeper.instance.worker(worker).encrypt(value)
  end
  
  # A helper method that calls Mack::Utils::Crypt::Keeper with the specified worker
  # and calls the decrypt method on that worker.
  def _decrypt(value, worker = :default)
    Mack::Utils::Crypt::Keeper.instance.worker(worker).decrypt(value)
  end
  
end
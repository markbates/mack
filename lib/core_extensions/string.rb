class String
  
  # Maps to Kernel _encrypt
  # 
  # Examples:
  #   "Hello World".encrypt
  #   "Hello World".encrypt(:my_crypt)
  def encrypt(worker = :default)
    _encrypt(self, worker)
  end
  
  # Maps to Kernel _decrypt
  # 
  # Examples:
  #   some_encrypted_string.decrypt
  #   some_encrypted_string.decrypt(:my_crypt)
  def decrypt(worker = :default)
    _decrypt(self, worker)
  end
  
end
class String
  
  # Camel cases the string.
  # 
  # Examples: 
  #   "user".camelcase # => User
  #   "my_blog".camelcase # => MyBlog
  #   "my/blog".camelcase # => My::Blog
  def camelcase
    self.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
  end
  
  # Returns a constant of the string.
  # 
  # Examples:
  #   "User".constantize # => User
  #   "HomeController".constantize # => HomeController
  #   "Mack::Configuration" # => Mack::Configuration
  def constantize
    Module.instance_eval("::#{self}")
  end
  
  # If the string is empty, this will return true.
  def blank?
    self == ""
  end
  
  # Maps to Mack::Utils::Inflector.instance.pluralize
  def plural
    Mack::Utils::Inflector.instance.pluralize(self)
  end
  
  # Maps to Mack::Utils::Inflector.instance.singularize
  def singular
    Mack::Utils::Inflector.instance.singularize(self)
  end
  
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
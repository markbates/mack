# Set up Mack constants, if they haven't already been set up.
unless Object.const_defined?("MACK_ENV")
  (Object::MACK_ENV = (ENV["MACK_ENV"] ||= "development")).to_sym
end
(Object::MACK_ROOT = (ENV["MACK_ROOT"] ||= FileUtils.pwd)) unless Object.const_defined?("MACK_ROOT")

Object::MACK_PUBLIC = File.join(MACK_ROOT, "public") unless Object.const_defined?("MACK_PUBLIC")
Object::MACK_APP = File.join(MACK_ROOT, "app") unless Object.const_defined?("MACK_APP")
Object::MACK_LIB = File.join(MACK_ROOT, "lib") unless Object.const_defined?("MACK_LIB")
Object::MACK_CONFIG = File.join(MACK_ROOT, "config") unless Object.const_defined?("MACK_CONFIG")
Object::MACK_VIEWS = File.join(MACK_APP, "views") unless Object.const_defined?("MACK_VIEWS")
Object::MACK_LAYOUTS = File.join(MACK_VIEWS, "layouts") unless Object.const_defined?("MACK_LAYOUTS")
Object::MACK_PLUGINS = File.join(MACK_ROOT, "vendor", "plugins") unless Object.const_defined?("MACK_PLUGINS")
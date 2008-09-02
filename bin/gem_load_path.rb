require 'fileutils'
require File.join(File.dirname(__FILE__), "env_handler")

vendor_path = File.join(FileUtils.pwd, 'vendor')

mack_path = File.join(vendor_path, 'framework', 'mack', 'lib')
mack_more_path = File.join(vendor_path, 'framework', 'mack-more')
# gem_path = File.join(vendor_path, 'gems')

if File.exists?(mack_path)
  $:.insert(0, File.expand_path(mack_path))
else
  if @mack_gem_version
    gem 'mack', @mack_gem_version
  else
    gem 'mack'
  end
end

if File.exists?(mack_more_path)
  Dir.glob(File.join(mack_more_path, '*')).each_with_index do |d, i|
    $:.insert(i+1, File.expand_path(File.join(d, 'lib')))
  end
end
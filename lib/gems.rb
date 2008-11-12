require File.join(File.dirname(__FILE__), 'mack', 'core_extensions', 'gem_kernel')

path = File.expand_path(File.join(File.dirname(__FILE__), 'gems'))
Gem.set_paths(path)

Dir.glob(File.join(path, '*')).each do |p|
  puts File.join(p, 'lib')
  $:.unshift(File.join(p, 'lib'))
  
  full_gem_name = File.basename(p)
  version = full_gem_name.match(/([\d\.?]+)/).to_s
  gem_name = full_gem_name.gsub("-#{version}", '')
  begin
    gem gem_name, "~> #{version}"
  rescue Gem::LoadError
    # puts File.join(p, 'lib')
    # $:.unshift(File.join(p, 'lib'))
  end
end
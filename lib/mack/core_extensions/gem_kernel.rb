module Kernel
  
  def add_gem_path(path)
    path = File.expand_path(path)
    unless Gem.path.include?(path)
      puts "adding gem_path: #{path}"
      Gem.path.insert(0, path)
      Gem.path.uniq!
      Dir.glob(File.join(path, '*')).each do |g|
        p = File.expand_path(File.join(g, 'lib'))
        puts "p: #{p}"
        $:.insert(0, p)
      end
    end
  end
  
end
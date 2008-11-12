# module Kernel
#   
#   def add_gem_path(path)
#     path = File.expand_path(path)
#     unless Gem.path.include?(path)
#       puts "adding gem_path: #{path}"
#       Gem.path.insert(0, path)
#       Gem.path.uniq!
#       $:.insert(0, path)
#       Dir.glob(File.join(path, '*')).each do |g|
#         if File.directory?(g)
#           p = File.expand_path(g)
#           puts "p: #{p}"
#           $:.insert(0, p)
#           p = File.join(p, 'lib')
#           puts "p: #{p}"
#           $:.insert(0, p)
#         end
#       end
#     end
#   end
#   
# end

unless Object.const_defined?('GEM_PATHS_MOD')
  module Gem
  
    class << self
      def clear_source_index
        @@source_index = nil
      end
  
      def clear_searcher
        @searcher = nil
      end
  
      def reset!
        Gem.clear_source_index
        Gem.clear_searcher
      end
  
      alias_method :__original_set_paths, :set_paths
  
      def set_paths(*gpaths)
        gpaths << Gem.path
        Gem.__original_set_paths(gpaths.flatten.uniq.join(File::PATH_SEPARATOR))
        Gem.reset!
        Gem.path.uniq!
      end
    end
  
  end
  GEM_PATHS_MOD = true
end
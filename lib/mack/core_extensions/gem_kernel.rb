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
        __original_set_paths([@gem_path, gpaths].flatten.compact.uniq.join(File::PATH_SEPARATOR))
        Gem.reset!
        @gem_path.uniq!
        @gem_path
      end
    end
  
  end
  GEM_PATHS_MOD = true
end
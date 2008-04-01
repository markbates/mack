module Mack
  module Utils
    class GemManager
      include Singleton

      attr_accessor :required_gem_list
      
      def initialize
        @required_gem_list = []
      end
      
      def add(name, version = nil, require_file = nil)
        @required_gem_list << Mack::Utils::GemManager::GemObject.new(name, version, require_file)
      end
      
      def do_requires
        @required_gem_list.each do |g|
          if g.version.nil?
            gem(g.name)
          else
            gem(g.name, g.version)
          end
          unless g.require_file.blank?
            require g.require_file
          end
        end
      end
      
      private
      class GemObject
        attr_accessor :name
        attr_accessor :version
        attr_accessor :require_file
        
        def initialize(name, version, require_file)
          self.name = name
          self.version = version
          self.require_file = require_file
        end
        
        def to_s
          t = "#{self.name.downcase}" 
          t << "-#{self.version}" unless self.version.blank?
          t
        end
        
      end
      
    end # GemManager
  end # Utils
end # Mack
module Mack
  module Utils
    class GemManager
      include Singleton

      attr_accessor :required_gem_list
      
      def initialize
        @required_gem_list = []
      end
      
      def add(name, version = nil, require_file = nil)
        # puts "name: #{name}; version: #{version}, require_file: #{require_file}"
        @required_gem_list << {:name => name, :version => version, :require_file => require_file}
      end
      
      def do_requires
        @required_gem_list.each do |g|
          if g[:version].nil?
            gem(g[:name])
          else
            gem(g[:name], g[:version])
          end
          unless g[:require_file].blank?
            require g[:require_file]
          end
        end
      end
      
    end # GemManager
  end # Utils
end # Mack
module Mack
  module Utils
    # This class is used to add gems to your application in an easy to use way.
    # 
    #   require_gems do |gem|
    #     gem.add :redgreen, :version => "1.2.2", :libs => :redgreen
    #     gem.add :termios
    #     gem.add "rubyzip", :source => "http:// gems.rubyforge.org"
    #   end
    class GemManager
      include Singleton

      attr_accessor :required_gem_list
      
      def initialize # :nodoc:
        @required_gem_list = []
      end
      
      # Adds a new gem to the system. This does NOT actually require the gem
      # or any of it's 'libs'. You need to call the do_requires method to actually
      # require any of the 'libs' defined for this gem.
      # 
      # Options:
      # * <code>:source => "http:// gems.rubyforge.org"</code>
      # * <code>:version => "1.2.3"</code>
      # * <code>:libs => "file" or :libs => ["file1", "file2"]</code>
      def add(name, options = {})
        @required_gem_list << Mack::Utils::GemManager::GemObject.new(name, options)
      end
      
      # Requires the gem and any libs that you've specified.
      def do_requires
        @required_gem_list.each do |g|
          begin
            if g.version?
              gem(g.name, g.version)
            else
              gem(g.name)
            end
            g.libs.each { |l| require l.to_s } if g.libs?
          rescue Exception => ex
            Mack.logger.warn "WARNING: gem #{g.name} [version: #{g.version}] is required, but is not installed"
          end
        end
      end
      
      private
      class GemObject # :nodoc:
        attr_accessor :name
        attr_accessor :version
        attr_accessor :libs
        attr_accessor :source
        
        def initialize(name, options = {})
          self.name = name
          self.version = options[:version]
          self.libs = [options[:libs]].flatten.compact
          self.source = options[:source]
        end
        
        def to_s
          t = self.name.to_s
          t << "-#{self.version}" if self.version?
          t.downcase
        end
        
        def libs?
          !self.libs.empty?
        end
        
        def version?
          !self.version.blank?
        end
        
        def source?
          !self.source.blank?
        end
        
      end
      
    end # GemManager
  end # Utils
end # Mack
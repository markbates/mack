module Mack
  module Utils
    module Orm
      module Migrations
        class Base
          
          attr_accessor :options
          
          def initialize(opts = {})
            self.options = {:direction => :up, :revert => 1}.merge(opts)
          end
          
          def run
            schema_info do |si| 
              case options[:direction]
              when :up
                Dir.glob(File.join(MACK_ROOT, "db", "migrations", "*.rb")).each do |migration|
                  require migration
                  migration = File.basename(migration, ".rb")
                  m_number = migration.match(/(^\d+)/).captures.last.to_i
                  if m_number > si.version
                    m_name = migration.match(/^\d+_(.+)/).captures.last
                    m_name.camelcase.constantize.up
                    si.version += 1
                    si.save
                  end
                end
              when :down
                
              end
            end
          end
          
          needs_method :schema_info
          
        end # Base
      end # Migrations
    end # Orm
  end # Utils
end # Mack
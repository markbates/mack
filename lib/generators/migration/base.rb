module Mack
  module Generator
    module Migration
      class Base < Mack::Generator::Base
        
        attr_reader :db_directory
        attr_reader :migrations_directory
        
        def initialize(env = {})
          super(env)
          @db_directory = File.join(MACK_ROOT, "db")
          @migrations_directory = File.join(@db_directory, "migrations")
        end
        
        def next_migration_number
          last = Dir.glob(File.join(@migrations_directory, "*.rb")).last
          if last
            return File.basename(last).match(/^\d+/).to_s.succ
          end
          return "001"
        end
        
      end # Base
    end # Migration
  end # Generator
end # Mack
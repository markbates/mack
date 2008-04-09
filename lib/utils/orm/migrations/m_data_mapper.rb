module Mack
  module Utils
    module Orm
      module Migrations
        class DataMapper < Mack::Utils::Orm::Migrations::Base
          
          def schema_info

            unless SchemaInfo.table.exists?
              SchemaInfo.table.create!
              SchemaInfo.create(:version => 0)
            end

            schema_info = SchemaInfo.first
            yield schema_info
            schema_info.save
          end
          
          private
          class SchemaInfo < DataMapper::Base
            property :version, :integer, :default => 0
          end
          
        end # DataMapper
      end # Migrations
    end # Orm
  end # Utils
end # Mack
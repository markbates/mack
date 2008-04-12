namespace :db do
  
  desc "Migrate the database through scripts in db/migrations"
  task :migrate => "mack:environment" do
    
    if using_data_mapper? 
      require 'data_mapper/migration'
      schema_info = data_mapper_schema_info
    elsif using_active_record?
      require 'active_record/migration'
      schema_info = active_record_schema_info
    end
    
    migration_files.each do |migration|
      require migration
      migration = File.basename(migration, ".rb")
      m_number = migration_number(migration)
      if m_number > schema_info.version
        migration_name(migration).camelcase.constantize.up
        schema_info.version += 1
        schema_info.save
      end
    end # glob
    
  end # migrate
  
  desc "Rolls the schema back to the previous version. Specify the number of steps with STEP=n"
  task :rollback => "mack:environment" do
    
    if using_data_mapper? 
      require 'data_mapper/migration'
      schema_info = data_mapper_schema_info
    elsif using_active_record?
      require 'active_record/migration'
      schema_info = active_record_schema_info
    end
    
    migrations = migration_files.reverse
    (ENV["STEP"] || 1).to_i.times do |step|
      migration = migrations[step]
      require migration
      migration = File.basename(migration, ".rb")
      m_number = migration_number(migration)
      if m_number == schema_info.version
        migration_name(migration).camelcase.constantize.down
        schema_info.version -= 1
        schema_info.save
      end
    end

  end # rollback
  
  private
  def migration_files
    Dir.glob(File.join(MACK_ROOT, "db", "migrations", "*.rb"))
  end
  
  def migration_number(migration)
    migration.match(/(^\d+)/).captures.last.to_i
  end
  
  def migration_name(migration)
    migration.match(/^\d+_(.+)/).captures.last
  end
  
  def data_mapper_schema_info
    unless DmSchemaInfo.table.exists?
      DmSchemaInfo.table.create!
      DmSchemaInfo.create(:version => 0)
    end
    DmSchemaInfo.first
  end # data_mapper_schema_info
  
  def active_record_schema_info
    unless ArSchemaInfo.table_exists?
      Db::Migrate::CreateArSchemaInfo.up
      ArSchemaInfo.create(:version => 0)
    end
    ArSchemaInfo.find(:first)
  end # active_record_schema_info
  
  begin
    module Db # :nodoc:
      module Migrate # :nodoc:
        class CreateArSchemaInfo < ActiveRecord::Migration # :nodoc:
          def self.up
            create_table :schema_info do |t|
              t.column :version, :integer, :default => 0
            end
          end # up
        end # CreateArSchemaInfo
      end # Migrate
    end # Db
  rescue Exception => e
  end

  
end # db
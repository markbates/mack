namespace :db do
  
  desc "Migrate the database through scripts in db/migrations"
  task :migrate => "db:schema:create" do
    
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
  task :rollback => "db:schema:create" do
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
      # if m_number > schema_info.version
      #   raise Mack::Errors::UnrunMigrations.new(m_number - schema_info.version)
      # end
      if m_number == schema_info.version
        migration_name(migration).camelcase.constantize.down
        schema_info.version -= 1
        schema_info.save
      end
    end

  end # rollback
  
  desc ""
  task :version => "db:schema:create" do
    if using_data_mapper? 
      schema_info = data_mapper_schema_info
    elsif using_active_record?
      schema_info = active_record_schema_info
    end
    puts "\nYour database is currently at version: #{schema_info.version}\n"
  end
  
  private
  namespace :schema do
    
    task :create => "mack:environment" do
      if using_data_mapper? 
        require 'data_mapper/migration'
        unless DmSchemaInfo.table.exists?
          DmSchemaInfo.table.create!
          DmSchemaInfo.create(:version => 0)
        end
      elsif using_active_record?
        require 'active_record/migration'
        class CreateArSchemaInfo < ActiveRecord::Migration # :nodoc:
          def self.up
            create_table :schema_info do |t|
              t.column :version, :integer, :default => 0
            end
          end # up
        end # CreateArSchemaInfo
        unless ArSchemaInfo.table_exists?
          CreateArSchemaInfo.up
          ArSchemaInfo.create(:version => 0)
        end
      end
    end # create
    
  end # schema
  
  
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
    DmSchemaInfo.first
  end # data_mapper_schema_info
  
  def active_record_schema_info
    ArSchemaInfo.find(:first)
  end # active_record_schema_info
  
end # db
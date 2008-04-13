namespace :db do
  
  desc "Migrate the database through scripts in db/migrations"
  task :migrate => "db:schema:create" do
    migration_files.each do |migration|
      require migration
      migration = File.basename(migration, ".rb")
      m_number = migration_number(migration)
      if m_number > @schema_info.version
        migration_name(migration).camelcase.constantize.up
        @schema_info.version += 1
        @schema_info.save
      end
    end # each
  end # migrate
  
  desc "Rolls the schema back to the previous version. Specify the number of steps with STEP=n"
  task :rollback => ["db:schema:create", "db:abort_if_pending_migrations"] do
    migrations = migration_files.reverse
    (ENV["STEP"] || 1).to_i.times do |step|
      migration = migrations[step]
      require migration
      migration = File.basename(migration, ".rb")
      m_number = migration_number(migration)
      if m_number == @schema_info.version
        migration_name(migration).camelcase.constantize.down
        @schema_info.version -= 1
        @schema_info.save
      end
    end

  end # rollback
  
  desc "Raises an error if there are pending migrations"
  task :abort_if_pending_migrations do
    migrations = migration_files.reverse
    return if migrations.empty?
    migration = migrations.first
    migration = File.basename(migration, ".rb")
    m_number = migration_number(migration)
    if m_number > @schema_info.version
      raise Mack::Errors::UnrunMigrations.new(m_number - @schema_info.version)
    end
  end
  
  desc "Displays the current schema version of your database"
  task :version => "db:schema:create" do
    puts "\nYour database is currently at version: #{@schema_info.version}\n"
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
        @schema_info = DmSchemaInfo.first
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
        @schema_info = ArSchemaInfo.find(:first)
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
  
end # db
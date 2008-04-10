namespace :db do
  
  desc "db:migrate"
  task :migrate => "mack:environment" do
    
    if using_data_mapper? 
      require 'data_mapper/migration'

      unless SchemaInfo.table.exists?
        SchemaInfo.table.create!
        SchemaInfo.create(:version => 0)
      end
      schema_info = SchemaInfo.first
      
    elsif using_active_record?
    end
    
    Dir.glob(File.join(MACK_ROOT, "db", "migrations", "*.rb")).each do |migration|
      require migration
      
      migration = File.basename(migration, ".rb")
      m_number = migration.match(/(^\d+)/).captures.last.to_i
      
      if m_number > schema_info.version
      
        m_name = migration.match(/^\d+_(.+)/).captures.last
      
        m_name.camelcase.constantize.up
        
        schema_info.version += 1
        schema_info.save
      end
      
    end
  end
  
end # db
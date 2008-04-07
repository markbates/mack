namespace :db do
  
  desc "db:migrate"
  task :migrate => "mack:environment" do
    require 'data_mapper/migration' if using_data_mapper?
    Dir.glob(File.join(MACK_ROOT, "db", "migrations", "*.rb")).each do |migration|
      require migration
      migration = File.basename(migration, ".rb")
      m_number = migration.match(/(^\d+)/).captures.last.to_i
      m_name = migration.match(/^\d+_(.+)/).captures.last
      
      m_name.camelcase.constantize.up
      
    end
  end
  
end # db
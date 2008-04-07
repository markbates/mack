class MigrationGenerator < Mack::Generator::Migration::Base

  require_param :name
  
  def generate # :nodoc:
    
    directory(migrations_directory)
    
    template_dir = File.join(File.dirname(__FILE__), "templates")
    
    template(File.join(template_dir, "migration.rb.template"), File.join(migrations_directory, "#{next_migration_number}_#{param(:name)}.rb"))
    
  end
  
end
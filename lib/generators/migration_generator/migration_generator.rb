class MigrationGenerator < Mack::Generator::Migration::Base

  require_param :name
  
  def generate # :nodoc:
    directory(migrations_directory)
    
    template_dir = File.join(File.dirname(__FILE__), "templates")
    
    @create_table_block = ""
    @drop_table_block = ""
    @table_name = param(:name).underscore.plural.gsub("create_", "")
    puts "@table_name: #{@table_name}"
    columns = ""
    cols = (param(:cols) || param(:columns))
    if cols
      cols = cols.split("|")
      cols.each_with_index do |v, i|
        x = v.split(":")
        columns << "      t.column :#{x.first}, :#{x.last}\n"
      end
      @create_table_block = "create_table :#{@table_name} do |t|\n"
      @create_table_block << columns
      @create_table_block << "    end"
      @drop_table_block = "drop_table :#{@table_name}"
    end
    
    template(File.join(template_dir, "migration.rb.template"), File.join(migrations_directory, "#{next_migration_number}_#{param(:name)}.rb"))
    
  end
  
end
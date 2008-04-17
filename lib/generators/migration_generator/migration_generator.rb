# This will generate a migration for your application.
# 
# Example without columns:
#   rake generate:migration name=create_users
# If using ActiveRecord generates:
# db/migrations/<number>_create_users.rb:
#   class CreateUsers < ActiveRecord::Migration
#     self.up
#     end
# 
#     self.down
#     end
#   end
# 
# If using DataMapper generates:
# db/migrations/<number>_create_users.rb:
#   class CreateUsers < DataMapper::Migration
#     self.up
#     end
# 
#     self.down
#     end
#   end
# 
# Example with columns:
#   rake generate:migration name=create_users cols=username:string|email_address:string|created_at:datetime|updated_at:datetime
# If using ActiveRecord generates:
# db/migrations/<number>_create_users.rb:
#   class CreateUsers < ActiveRecord::Migration
#     self.up
#       create_table :users do |t|
#         t.column :username, :string
#         t.column :email_address, :string
#         t.column :created_at, :datetime
#         t.column :updated_at, :datetime
#     end
# 
#     self.down
#       drop_table :users
#     end
#   end
# 
# If using DataMapper generates:
# db/migrations/<number>_create_users.rb:
#   class CreateUsers < DataMapper::Migration
#     self.up
#       create_table :users do |t|
#         t.column :username, :string
#         t.column :email_address, :string
#         t.column :created_at, :datetime
#         t.column :updated_at, :datetime
#     end
# 
#     self.down
#       drop_table :users
#     end
#   end
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
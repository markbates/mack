# This will generate an ORM 'model' for your application based on the specified ORM you're using. 
# 
# Example without columns:
#   rake generate:model name=user
# If using ActiveRecord generates:
# app/models/user.rb:
#   class User < ActiveRecord::Base
#   end
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
# app/models/user.rb:
#   class User < DataMapper::Base
#   end
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
#   rake generate:model name=user cols=username:string,email_address:string,created_at:datetime,updated_at:datetime
# If using ActiveRecord generates:
# app/models/user.rb:
#   class User < ActiveRecord::Base
#   end
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
# app/models/user.rb:
#   class User < DataMapper::Base
#     property :username, :string
#     property :email_address, :string
#     property :created_at, :datetime
#     property :updated_at, :datetime
#   end
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
class ModelGenerator < Genosaurus::Base
  
  require_param :name
  
  # def generate
  #   directory(File.join(MACK_APP, "models"))
  #   
  #   template(File.join(File.dirname(__FILE__), "templates", "app", "models", "#{app_config.orm}.rb.template"), File.join(MACK_APP, "models", "#{param(:name).singular.underscore}.rb"), :force => param(:force))
  #   MigrationGenerator.new(@env.merge({"name" => "create_#{param(:name).plural}"})).generate
  # end
  
  def after_generate
    MigrationGenerator.run(@options.merge({"name" => "create_#{param(:name).plural}"}))
  end
  
end
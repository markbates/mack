require File.dirname(__FILE__) + '/../../test_helper.rb'

class DbTasksTest < Test::Unit::TestCase
  
  def setup
    cleanup
    FileUtils.mkdir_p(File.join(fake_app_db_dir, "migrations"))
    FileUtils.mkdir_p(File.join(MACK_APP, "models"))
  end
  
  def teardown
    cleanup
  end

  # def test_db_migrate_active_record_up
  #   use_active_record do
  #     assert !ArSchemaInfo.table_exists?
  #     rake_task("db:migrate") do
  #       assert ArSchemaInfo.table_exists?
  #       si = ArSchemaInfo.find(:first)
  #       assert_equal 0, si.version
  #     end
  #     File.open(File.join(fake_app_migration_dir, "001_create_users.rb"), "w") do |f|
  #       f.puts dm_create_users_migration
  #     end
  #     File.open(user_rb, "w") do |f|
  #       f.puts "class User < DataMapper::Base"
  #       f.puts "property :username, :string"
  #       f.puts "property :email, :string"
  #       f.puts "end"
  #     end
  #     require user_rb
  #     assert !User.table_exists?
  #     rake_task("db:migrate")
  #     assert User.table_exists?
  #     si = ArSchemaInfo.find(:first)
  #     assert_equal 1, si.version
  #     File.open(File.join(fake_app_migration_dir, "002_create_posts.rb"), "w") do |f|
  #       f.puts dm_create_posts_migration
  #     end
  #     File.open(post_rb, "w") do |f|
  #       f.puts "class Post < ActiveRecord::Base"
  #       f.puts "end"
  #     end
  #     require post_rb
  #     assert !Post.table_exists?
  #     rake_task("db:migrate")
  #     assert Post.table_exists?
  #     si = ArSchemaInfo.first
  #     assert_equal 2, si.version
  #   end
  # end
  
  def test_db_migrate_data_mapper_up
    use_data_mapper do
      assert !DmSchemaInfo.table.exists?
      rake_task("db:migrate") do
        assert DmSchemaInfo.table.exists?
        si = DmSchemaInfo.first
        assert_equal 0, si.version
      end
      File.open(File.join(fake_app_migration_dir, "001_create_users.rb"), "w") do |f|
        f.puts dm_create_users_migration
      end
      File.open(user_rb, "w") do |f|
        f.puts "class User < DataMapper::Base"
        f.puts "property :username, :string"
        f.puts "property :email, :string"
        f.puts "end"
      end
      require user_rb
      assert !User.table.exists?
      rake_task("db:migrate")
      assert User.table.exists?
      si = DmSchemaInfo.first
      assert_equal 1, si.version
      File.open(File.join(fake_app_migration_dir, "002_create_posts.rb"), "w") do |f|
        f.puts dm_create_posts_migration
      end
      File.open(post_rb, "w") do |f|
        f.puts "class Post < DataMapper::Base"
        f.puts "property :user_id, :integer"
        f.puts "property :body, :text"
        f.puts "end"
      end
      require post_rb
      assert !Post.table.exists?
      rake_task("db:migrate")
      assert Post.table.exists?
      si = DmSchemaInfo.first
      assert_equal 2, si.version
    end
  end
  
  private
  def ar_create_users_migration
    <<-MIG
class CreateUsers < ActiveRecord::Migration
#{common_create_users_migration}
end
MIG
  end 

  def ar_create_posts_migration
    <<-MIG
class CreatePosts < ActiveRecord::Migration
#{common_create_posts_migration}
end
MIG
  end
  
  def dm_create_users_migration
    <<-MIG
class CreateUsers < DataMapper::Migration
#{common_create_users_migration}
end
MIG
  end 
  
  def dm_create_posts_migration
    <<-MIG
class CreatePosts < DataMapper::Migration
#{common_create_posts_migration}
end
MIG
  end
  
  def common_create_posts_migration
    <<-MIG
  def self.up
    create_table :posts do |t|
      t.column :user_id, :integer
      t.column :body, :text
    end
  end

  def self.down
    drop_table :posts
  end
MIG
  end
  
  def common_create_users_migration
<<-MIG
  def self.up
    create_table :users do |t|
      t.column :username, :string
      t.column :email, :string
    end
  end

  def self.down
    drop_table :users
  end
MIG
  end
  
  def user_rb
    File.join(MACK_APP, "models", "user.rb")
  end
  
  def post_rb
    File.join(MACK_APP, "models", "post.rb")
  end
  
  def cleanup
    db_loc = File.join(MACK_ROOT, "db", "fake_application_test.db")
    FileUtils.rm_r(db_loc) if File.exists?(db_loc)
    FileUtils.rm_r(fake_app_migration_dir) if File.exists?(fake_app_migration_dir)
    FileUtils.rm_r(user_rb) if File.exists?(user_rb)
    FileUtils.rm_r(post_rb) if File.exists?(post_rb)
  end
  
  def fake_app_migration_dir
    File.join(fake_app_db_dir, "migrations")
  end
  
  def fake_app_db_dir
    File.join(MACK_ROOT, "db")
  end
  
end
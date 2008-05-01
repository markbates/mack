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
  
  def test_db_rollback_data_mapper
    test_db_migrate_data_mapper
    si = DmSchemaInfo.first
    assert_equal 2, si.version
    rake_task("db:rollback")
    si = DmSchemaInfo.first
    assert_equal 1, si.version
    assert !DmPost.table.exists?
  end
  
  def test_db_rollback_data_mapper_two_steps
    test_db_migrate_data_mapper
    si = DmSchemaInfo.first
    assert_equal 2, si.version
    rake_task("db:rollback", "STEP" => "2")
    si = DmSchemaInfo.first
    assert_equal 0, si.version
    assert !DmPost.table.exists?
    assert !DmUser.table.exists?
  end
  
  def test_db_rollback_data_mapper_unrun_migrations
    test_db_migrate_data_mapper
    MigrationGenerator.run("name" => "create_comments")
    si = DmSchemaInfo.first
    assert_equal 2, si.version
    assert_raise(Mack::Errors::UnrunMigrations) { rake_task("db:rollback") }
  end

  def test_db_migrate_data_mapper
    assert !DmSchemaInfo.table.exists?
    rake_task("db:migrate") do
      assert DmSchemaInfo.table.exists?
      si = DmSchemaInfo.first
      assert_equal 0, si.version
    end
    File.open(File.join(fake_app_migration_dir, "001_dm_create_users.rb"), "w") do |f|
      f.puts dm_create_users_migration
    end
    File.open(user_rb, "w") do |f|
      f.puts "class DmUser"
      f.puts "include DataMapper::Persistence"
      f.puts "set_table_name 'users'"
      f.puts "property :username, :string"
      f.puts "property :email, :string"
      f.puts "end"
    end
    load user_rb
    assert !DmUser.table.exists?
    rake_task("db:migrate")
    assert DmUser.table.exists?
    si = DmSchemaInfo.first
    assert_equal 1, si.version
    File.open(File.join(fake_app_migration_dir, "002_dm_create_posts.rb"), "w") do |f|
      f.puts dm_create_posts_migration
    end
    File.open(post_rb, "w") do |f|
      f.puts "class DmPost"
      f.puts "include DataMapper::Persistence"
      f.puts "set_table_name 'posts'"
      f.puts "property :user_id, :integer"
      f.puts "property :body, :text"
      f.puts "end"
    end
    load post_rb
    assert !DmPost.table.exists?
    rake_task("db:migrate")
    assert DmPost.table.exists?
    si = DmSchemaInfo.first
    assert_equal 2, si.version
  end
  
  private
  
  def dm_create_users_migration
    <<-MIG
class DmCreateUsers < DataMapper::Migration
#{common_create_users_migration}
end
MIG
  end 
  
  def dm_create_posts_migration
    <<-MIG
class DmCreatePosts < DataMapper::Migration
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
    database.adapter.flush_connections!
    db_loc = File.join(fake_app_db_dir, "fake_application_test.db")
    FileUtils.rm_rf(db_loc) if File.exists?(db_loc)
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
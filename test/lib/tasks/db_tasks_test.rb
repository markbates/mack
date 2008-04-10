require File.dirname(__FILE__) + '/../../test_helper.rb'

class DbTasksTest < Test::Unit::TestCase
  
  def setup
    cleanup
  end
  
  def teardown
    cleanup
  end
  
  def test_db_migrate_data_mapper
    use_data_mapper do
      assert !SchemaInfo.table.exists?
      rake_task("db:migrate", {"USER" => "foobar"}) do
        assert SchemaInfo.table.exists?
        si = SchemaInfo.first
        assert_equal 0, si.version
      end
      MigrationGenerator.new("name" => "create_users").run
      mig = File.open(File.join(fake_app_migration_dir, "001_create_users.rb")).read
      puts mig
      up_mig = <<-UP_MIG
  def self.up
    create_table :users do |t|
      t.column :username, :string
      t.column :email, :string
    end
  end
UP_MIG
      mig.gsub!("  def self.up\n  end", up_mig)
      puts mig
      down_mig = <<-DOWN_MIG
  def self.down
    drop_table :users
  end
DOWN_MIG
      mig.gsub!("  def self.down\n  end", down_mig)
      puts mig
    end
  end
  
  private
  def cleanup
    db_loc = File.join(MACK_ROOT, "db", "fake_application_test.db")
    FileUtils.rm_r(db_loc) if File.exists?(db_loc)
    
    FileUtils.rm_r(fake_app_migration_dir) if File.exists?(fake_app_migration_dir)
  end
  
  def fake_app_migration_dir
    File.join(fake_app_db_dir, "migrations")
  end
  
  def fake_app_db_dir
    File.join(MACK_ROOT, "db")
  end
  
end
require File.dirname(__FILE__) + '/../../test_helper.rb'

class MigrationGeneratorTest < Test::Unit::TestCase
  
  def setup
    begin
      FileUtils.rm_r(fake_app_migration_dir)
    rescue Exception => e
    end
  end
  
  def teardown
    begin
      FileUtils.rm_r(fake_app_migration_dir)
    rescue Exception => e
    end
  end
  
  def test_next_migration_number
    mg = MigrationGenerator.new("NAME" => "foo")
    assert_equal "001", mg.next_migration_number
    mg.directory(mg.migrations_directory)
    assert File.exists?(fake_app_migration_dir)
    File.open(File.join(fake_app_migration_dir, "001_foo.rb"), "w") {|f| f.puts ""}
    assert_equal "002", mg.next_migration_number
  end
  
  def test_generate_active_record
    temp_app_config("orm" => "activerecord") do
      assert app_config.orm = "activerecord"
      generate_common
      assert_match "class FooBar < ActiveRecord::Migration", @file_body
    end
  end
  
  def test_generate_data_mapper
    temp_app_config("orm" => "data_mapper") do
      assert app_config.orm = "data_mapper"
      generate_common
      assert_match "class FooBar < DataMapper::Migration", @file_body
    end
  end
  
  def generate_common
    mg = MigrationGenerator.new("NAME" => "foo_bar")
    mg.generate
    assert File.exists?(fake_app_migration_dir)
    assert File.exists?(File.join(fake_app_migration_dir, "001_foo_bar.rb"))
    File.open(File.join(fake_app_migration_dir, "001_foo_bar.rb"), "r") do |file|
      @file_body = file.read
    end
  end
  
  private
  def fake_app_migration_dir
    File.join(fake_app_db_dir, "migrations")
  end
  
  def fake_app_db_dir
    File.join(MACK_ROOT, "db")
  end
  
end
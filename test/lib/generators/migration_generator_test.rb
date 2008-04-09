require File.dirname(__FILE__) + '/../../test_helper.rb'

class MigrationGeneratorTest < Test::Unit::TestCase
  
  def setup
    if File.exists?(fake_app_migration_dir)
      FileUtils.rm_r(fake_app_migration_dir)
    end
  end
  
  def teardown
    if File.exists?(fake_app_migration_dir)
      FileUtils.rm_r(fake_app_migration_dir)
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
    temp_app_config("orm" => "active_record") do
      assert app_config.orm = "active_record"
      generate_common
      mig = <<-MIG
class FooBar < ActiveRecord::Migration

  def self.up
  end

  def self.down
  end

end
MIG
      assert_equal mig, @file_body
    end
  end
  
  def test_generate_data_mapper
    temp_app_config("orm" => "data_mapper") do
      assert app_config.orm = "data_mapper"
      generate_common
      mig = <<-MIG
class FooBar < DataMapper::Migration

  def self.up
  end

  def self.down
  end

end
MIG
      assert_equal mig, @file_body
    end
  end
  
  def generate_common
    5.times do |i|
      mg = MigrationGenerator.new("NAME" => "foo_bar")
      mg.run
      assert File.exists?(fake_app_migration_dir)
      assert File.exists?(File.join(fake_app_migration_dir, "00#{i+1}_foo_bar.rb"))
      File.open(File.join(fake_app_migration_dir, "00#{i+1}_foo_bar.rb"), "r") do |file|
        @file_body = file.read
      end
    end
  end
  
  def test_required_params
    assert_raise(Mack::Errors::RequiredGeneratorParameterMissing) { MigrationGenerator.new }
    mg = MigrationGenerator.new("NAME" => "foo")
    assert_not_nil mg
  end
  
  private
  def fake_app_migration_dir
    File.join(fake_app_db_dir, "migrations")
  end
  
  def fake_app_db_dir
    File.join(MACK_ROOT, "db")
  end
  
end
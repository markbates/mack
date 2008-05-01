require File.dirname(__FILE__) + '/../../test_helper.rb'

class MigrationGeneratorTest < Test::Unit::TestCase
  
  def test_next_migration_number
    mg = MigrationGenerator.new("NAME" => "foo")
    assert_equal "001", mg.next_migration_number
    FileUtils.mkdir_p(migrations_directory)
    assert File.exists?(migrations_directory)
    File.open(File.join(migrations_directory, "001_foo.rb"), "w") {|f| f.puts ""}
    assert_equal "002", mg.next_migration_number
  end
  
  def test_generate_data_mapper
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

  def test_generate_data_mapper_with_columns
    generate_common({"NAME" => "create_users", "cols" => "username:string,email_address:string,created_at:datetime,updated_at:datetime"})
    mig = <<-MIG
class CreateUsers < DataMapper::Migration

  def self.up
    create_table :users do |t|
      t.column :username, :string
      t.column :email_address, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :users
  end

end
MIG
    assert_equal mig, @file_body
  end
  
  def generate_common(opts = {})
    5.times do |i|
      options = {"NAME" => "foo_bar"}.merge(opts)
      mg = MigrationGenerator.run(options)
      assert File.exists?(migrations_directory)
      assert File.exists?(File.join(migrations_directory, "00#{i+1}_#{options["NAME"]}.rb"))
      File.open(File.join(migrations_directory, "00#{i+1}_#{options["NAME"]}.rb"), "r") do |file|
        @file_body = file.read
      end
    end
  end
  
  def test_required_params
    assert_raise(ArgumentError) { MigrationGenerator.new }
    mg = MigrationGenerator.new("NAME" => "foo")
    assert_not_nil mg
  end
  
  def cleanup
    clean_migrations_directory
  end
  
end
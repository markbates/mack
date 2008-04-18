require File.dirname(__FILE__) + '/../../test_helper.rb'

class ModelGeneratorTest < Test::Unit::TestCase
  
  def setup
    FileUtils.rm_r(model_loc) if File.exists?(model_loc)
    FileUtils.rm_r(fake_app_migration_dir) if File.exists?(fake_app_migration_dir)
  end
  
  def teardown
    FileUtils.rm_r(model_loc) if File.exists?(model_loc)
    FileUtils.rm_r(fake_app_migration_dir) if File.exists?(fake_app_migration_dir)
  end
  
  def test_generate_active_record
    use_active_record do 
      ModelGenerator.new("name" => "album").generate
      assert File.exists?(model_loc)
      assert_equal ar_album, File.open(model_loc).read
      assert File.exists?(migration_loc)
    end
  end
  
  def test_generate_data_mapper
    use_data_mapper do 
      ModelGenerator.new("name" => "album").generate
      assert File.exists?(model_loc)
      assert_equal dm_album, File.open(model_loc).read
      assert File.exists?(migration_loc)
    end
  end
  
  def test_generate_data_mapper_with_columns
    use_data_mapper do 
      ModelGenerator.new("name" => "albums", "cols" => "title:string,artist_id:integer,description:text").generate
      assert File.exists?(model_loc)
      assert_equal dm_album_with_columns, File.open(model_loc).read
      assert File.exists?(migration_loc)
    end
  end
  
  
  private
  def model_loc
    File.join(models_dir, "album.rb")
  end
  
  def models_dir
    File.join(MACK_APP, "models")
  end
  
  def migration_loc
    File.join(fake_app_migration_dir, "001_create_albums.rb")
  end
  
  def fake_app_migration_dir
    File.join(fake_app_db_dir, "migrations")
  end
  
  def fake_app_db_dir
    File.join(MACK_ROOT, "db")
  end
  
  def ar_album
    <<-ALBUM
class Album < ActiveRecord::Base
end
ALBUM
  end
  
  def dm_album
    <<-ALBUM
class Album < DataMapper::Base
end
ALBUM
  end
  
  def dm_album_with_columns
    <<-ALBUM
class Album < DataMapper::Base
  property :title, :string
  property :artist_id, :integer
  property :description, :text
end
ALBUM
  end
  
end
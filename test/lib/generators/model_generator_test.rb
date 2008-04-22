require File.dirname(__FILE__) + '/../../test_helper.rb'

class ModelGeneratorTest < Test::Unit::TestCase
  
  def setup
    cleanup
  end
  
  def teardown
    cleanup
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
  
  def test_unit_test_created
    use_data_mapper do 
      ModelGenerator.new("name" => "album").generate
      assert File.exists?(unit_test_loc)
      assert_equal unit_test, File.open(unit_test_loc).read
    end
  end
  
  private
  def cleanup
    if File.exists?(test_dir)
      FileUtils.rm_r(test_dir)
    end
    FileUtils.rm_r(model_loc) if File.exists?(model_loc)
    FileUtils.rm_r(fake_app_migration_dir) if File.exists?(fake_app_migration_dir)
    FileUtils.rm_r(unit_test_loc) if File.exists?(unit_test_loc)    
  end
  
  def test_dir
    File.join(MACK_ROOT, "test")
  end
  
  def unit_test_loc
    File.join(MACK_ROOT, "test", "unit", "album_test.rb")
  end
  
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
  
  def unit_test
    <<-UT
require File.dirname(__FILE__) + '/../test_helper.rb'

class AlbumTest < Test::Unit::TestCase
  
  def test_truth
    assert true
  end
  
end
UT
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
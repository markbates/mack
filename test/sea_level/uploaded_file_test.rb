require File.dirname(__FILE__) + '/../test_helper.rb'

class ControllerBaseTest < Test::Unit::TestCase
  
  def setup
    FileUtils.cp(File.join(Mack::Configuration.root, "public", "images", "logo.gif"), File.join(Mack::Configuration.root, "public", "something", "logo.gif"))
    @uploaded_file = Mack::Request::UploadedFile.new(:type => "image/gif", :filename => "logo.gif", :head => "Content-Disposition: form-data; name=\"my_new_file\"; filename=\"logo.gif\"\r\nContent-Type: image/gif\r\n", :tempfile => File.open(File.join(Mack::Configuration.root, "public", "something", "logo.gif")), :name=>"my_new_file")
  end                                                                                
  
  def teardown
    FileUtils.rm_rf(File.join(Mack::Configuration.root, "tmp"))
  end
  
  def test_save_to
    @uploaded_file.save_to(File.join(Mack::Configuration.root, "tmp", @uploaded_file.file_name))
    assert File.exists?(File.join(Mack::Configuration.root, "tmp", @uploaded_file.file_name))
    assert !File.exists?(@uploaded_file.temp_file.path)    
  end
  
  def test_save_to_array
    @uploaded_file.save_to([Mack::Configuration.root, "tmp", @uploaded_file.file_name])
    assert File.exists?(File.join(Mack::Configuration.root, "tmp", @uploaded_file.file_name))
    assert !File.exists?(@uploaded_file.temp_file.path)    
  end
  
  def test_save_to_implied_array
    @uploaded_file.save_to(Mack::Configuration.root, "tmp", @uploaded_file.file_name)
    assert File.exists?(File.join(Mack::Configuration.root, "tmp", @uploaded_file.file_name))
    assert !File.exists?(@uploaded_file.temp_file.path)    
  end
  
  def test_destination_path_equals
    @uploaded_file.destination_path = File.join("foo", "bar")
    assert_equal "foo/bar", @uploaded_file.destination_path
    @uploaded_file.destination_path = ["foo", "bar"]
    assert_equal "foo/bar", @uploaded_file.destination_path
    @uploaded_file.destination_path = "pickled", "eggs"
    assert_equal "pickled/eggs", @uploaded_file.destination_path
  end
  
  def test_save
    path = File.join(Mack::Configuration.root, "tmp", @uploaded_file.file_name)
    @uploaded_file.destination_path = path
    @uploaded_file.save
    assert File.exists?(File.join(Mack::Configuration.root, "tmp", @uploaded_file.file_name))
    assert !File.exists?(@uploaded_file.temp_file.path)
  end
  
  def test_save_no_destination_path
    assert_raise(ArgumentError) { @uploaded_file.save }
  end
  
end
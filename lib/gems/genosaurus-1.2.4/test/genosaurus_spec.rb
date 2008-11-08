require File.join(File.dirname(__FILE__), "spec_helper")

describe Genosaurus do
  
  before(:each) do
    clean_tmp
  end
  
  after(:each) do
    clean_tmp
  end
  
  it "should describe it's required parameters" do
    desc = ManyRequiresGenerator.describe
    desc.should match(/ManyRequiresGenerator/)
    desc.should match(/Required Parameter: 'first_name'/)
    desc.should match(/Required Parameter: 'last_name'/)
    desc.should match(/This generator requires many things/)
  end
  
  it "test_simple_implied_generator" do
    hello_file = File.join($genosaurus_output_directory, "hello_world.rb")
    goodbye_file = File.join($genosaurus_output_directory, "goodbye_world.rb")
    File.should_not be_exists(hello_file)
    File.should_not be_exists(goodbye_file)
    @generator = HelloGoodbyeGenerator.run("name" => "Mark")
    File.should be_exists(hello_file)
    File.should be_exists(goodbye_file)
    File.read(hello_file).should == "Hello Mark\n"
    File.read(goodbye_file).should == "Goodbye cruel world! Love, Mark\n"
  end

  it "test_simple_implied_manifest" do
    @generator = HelloGoodbyeGenerator.new("name" => "Mark")
    manifest = @generator.manifest
    manifest.should be_is_a(Hash)
    manifest.size.should == 2
    temp1 = manifest["template_1"]
    temp1["type"].should == "file"
    temp1["template_path"].should == File.join(File.dirname(__FILE__), "lib", "hello_goodbye_generator", "templates", "goodbye_world.rb.template")
    temp1["output_path"].should == "goodbye_world.rb"
    temp2 = manifest["template_2"]
    temp2["type"].should == "file"
    temp2["template_path"].should == File.join(File.dirname(__FILE__), "lib", "hello_goodbye_generator", "templates", "hello_world.rb.template")
    temp2["output_path"].should == "hello_world.rb"
  end
  
  it "should take a hash of options and raise an exception for the required ones" do
    lambda { HelloGoodbyeGenerator.new }.should raise_error(ArgumentError)
    @generator = HelloGoodbyeGenerator.new("name" => :foo)
    @generator.should_not be_nil
    @generator.param(:name).should == :foo
  end
  
  it "should take an array of options and raise an exception for the required ones" do
    lambda { HelloGoodbyeGenerator.new }.should raise_error(ArgumentError)
    @generator = HelloGoodbyeGenerator.new(:foo)
    @generator.should_not be_nil
    @generator.param(:name).should == :foo
  end
  
  it "test_complex_implied_generator" do
    album_dir = File.join($genosaurus_output_directory, "beatles", "albums")
    lyrics_file = File.join($genosaurus_output_directory, "beatles", "lyrics", "i_am_the_walrus.txt")
    File.should_not be_exists(album_dir)
    File.should_not be_exists(lyrics_file)
    @generator = IAmTheWalrusGenerator.run("name" => "i_am_the_walrus")
    File.should be_exists(album_dir)
    File.should be_exists(lyrics_file)
    File.read(lyrics_file).should == "Lyrics for: I Am The Walrus\n"
  end
  
  it "test_simple_yml_manifest" do
    @generator = StrawberryFieldsGenerator.new
    manifest = @generator.manifest
    manifest.should be_is_a(Hash)
    manifest.size.should == 2
    info = manifest["directory_1"]
    info["output_path"].should == "beatles/albums/magical_mystery_tour"
    info["type"].should == "directory"
    info = manifest["template_1"]
    info["template_path"].should == File.join(File.dirname(__FILE__), "lib", "strawberry_fields_generator", "templates", "fields.txt")
    info["output_path"].should == "beatles/albums/magical_mystery_tour/lyrics/strawberry_fields_forever.lyrics"
  end
  
  it "test_directory" do
    @generator = DirectoryGenerator.run
    File.should be_exists(File.join($genosaurus_output_directory, "months", "january"))
    File.should be_exists(File.join($genosaurus_output_directory, "months", "february"))
    File.should be_exists(File.join($genosaurus_output_directory, "months", "march"))
  end
  
  it "test_copy" do
    File.should_not be_exists(File.join($genosaurus_output_directory, "hw.txt"))
    @generator = CopyMachineGenerator.run
    File.should be_exists(File.join($genosaurus_output_directory, "hw.txt"))
  end
  
  def clean_tmp
    FileUtils.rm_rf($genosaurus_output_directory, :verbose => false)
  end
  
end
require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe ViewHelperGenerator do
  
  before(:each) do
    FileUtils.rm_rf(File.join(Mack.root, "app", "helpers", "views", "zoo_helper.rb"))
    FileUtils.rm_rf(File.join(Mack.root, "test", "helpers", "views", "zoo_helper_test.rb"))
    FileUtils.rm_rf(File.join(Mack.root, "test", "helpers", "views", "zoo_helper_spec.rb"))
  end
  
  after(:each) do
    FileUtils.rm_rf(File.join(Mack.root, "app", "helpers", "views", "zoo_helper.rb"))
    FileUtils.rm_rf(File.join(Mack.root, "test", "helpers", "views", "zoo_helper_test.rb"))
    FileUtils.rm_rf(File.join(Mack.root, "test", "helpers", "views", "zoo_helper_spec.rb"))
  end
  
  it "should require a name parameter" do
    lambda{ViewHelperGenerator.new}.should raise_error(ArgumentError)
    ViewHelperGenerator.new("name" => "zoo").should be_instance_of(ViewHelperGenerator)
  end
  
  it "should generate a controller helper" do
    file = File.join(Mack.root, "app", "helpers", "views", "zoo_helper.rb")
    File.should_not be_exists(file)
    ViewHelperGenerator.run("name" => "zoo")
    File.should be_exists(file)
    File.read(file).should == fixture("zoo_helper.rb")
  end
  
  it "should generate a Test::Unit::TestCase test if using the Test::Unit::TestCase framework" do
    temp_app_config("mack::testing_framework" => "test_case") do
      file = File.join(Mack.root, "test", "helpers", "views", "zoo_helper_test.rb")
      File.should_not be_exists(file)
      ViewHelperGenerator.run("name" => "zoo")
      File.should be_exists(file)
      File.read(file).should == fixture("zoo_helper_test.rb")
    end
  end
  
  it "should generate a RSpec test if using the RSpec framework" do
    file = File.join(Mack.root, "test", "helpers", "views", "zoo_helper_spec.rb")
    File.should_not be_exists(file)
    ViewHelperGenerator.run("name" => "zoo")
    File.should be_exists(file)
    File.read(file).should == fixture("zoo_helper_spec.rb")
  end
  
end
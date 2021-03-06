require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe ControllerHelperGenerator do
  
  before(:each) do
    FileUtils.rm_rf(Mack::Paths.controller_helpers("zoos_controller_helper.rb"))
    FileUtils.rm_rf(Mack::Paths.test)
  end
  
  after(:each) do
    FileUtils.rm_rf(Mack::Paths.controller_helpers("zoos_controller_helper.rb"))
    FileUtils.rm_rf(Mack::Paths.test)
  end
  
  it "should require a name parameter" do
    lambda{ControllerHelperGenerator.new}.should raise_error(ArgumentError)
    ControllerHelperGenerator.new("name" => "zoo").should be_instance_of(ControllerHelperGenerator)
  end
  
  it "should generate a controller helper" do
    file = Mack::Paths.controller_helpers("zoos_controller_helper.rb")
    File.should_not be_exists(file)
    ControllerHelperGenerator.run("name" => "zoo")
    File.should be_exists(file)
    File.read(file).should == fixture("zoos_controller_helper.rb")
  end
  
  it "should generate a Test::Unit::TestCase test if using the Test::Unit::TestCase framework" do
    temp_app_config(:mack => {:testing_framework => "test_case"}) do
      file = Mack::Paths.controller_helper_tests("zoos_controller_helper_test.rb")
      File.should_not be_exists(file)
      ControllerHelperGenerator.run("name" => "zoo")
      File.should be_exists(file)
      File.read(file).should == fixture("zoos_controller_helper_test.rb")
    end
  end
  
  it "should generate a RSpec test if using the RSpec framework" do
    file = Mack::Paths.controller_helper_tests("zoos_controller_helper_spec.rb")
    File.should_not be_exists(file)
    ControllerHelperGenerator.run("name" => "zoo")
    File.should be_exists(file)
    File.read(file).should == fixture("zoos_controller_helper_spec.rb")
  end
  
end
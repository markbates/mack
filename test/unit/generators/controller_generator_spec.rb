require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe ControllerGenerator do
  
  def common_cleanup
    FileUtils.rm_rf(File.join(Mack.root, "app", "controllers", "zoos_controller.rb"))
    FileUtils.rm_rf(File.join(Mack.root, "app", "views", "zoos"))
    FileUtils.rm_rf(File.join(Mack.root, "app", "helpers", "controllers", "zoos_controller_helper.rb"))
    FileUtils.rm_rf(File.join(Mack.root, "test"))
  end
  
  before(:each) do
    common_cleanup
  end
  
  after(:each) do
    common_cleanup
  end
  
  it "should require a name parameter" do
    lambda{ControllerGenerator.new}.should raise_error(ArgumentError)
    ControllerGenerator.new("name" => "zoo").should be_instance_of(ControllerGenerator)
  end
  
  it "should also take an optional 'actions' parameter" do
    index = File.join(Mack.root, "app", "views", "zoos", "index.html.erb")
    show = File.join(Mack.root, "app", "views", "zoos", "show.html.erb")
    file = File.join(Mack.root, "app", "controllers", "zoos_controller.rb")
    ControllerGenerator.run("name" => "zoo", "actions" => "index,show")
    File.should be_exists(file)
    File.read(file).should == fixture("zoos_controller_with_actions.rb")
    File.should be_exists(index)
    File.read(index).should match(/<h1>ZoosController#index<\/h1>/)
    File.should be_exists(show)
    File.read(show).should match(/<p>You can find me in app\/views\/zoos\/show.html.erb<\/p>/)
  end
  
  it "should generate a controller" do
    file = File.join(Mack.root, "app", "controllers", "zoos_controller.rb")
    File.should_not be_exists(file)
    ControllerGenerator.run("name" => "zoo")
    File.should be_exists(file)
    File.read(file).should == fixture("zoos_controller.rb")
    File.should be_exists(File.join(Mack.root, "app", "views", "zoos"))
  end
  
  it "should generate a controller helper" do
    file = File.join(Mack.root, "app", "helpers", "controllers", "zoos_controller_helper.rb")
    File.should_not be_exists(file)
    ControllerGenerator.run("name" => "zoo")
    File.should be_exists(file)
    File.read(file).should == fixture("zoos_controller_helper.rb")
  end
  
  it "should generate a Test::Unit::TestCase test if using the Test::Unit::TestCase framework" do
    temp_app_config("mack::testing_framework" => "test_case") do
      file = File.join(Mack.root, "test", "helpers", "controllers", "zoos_controller_helper_test.rb")
      File.should_not be_exists(file)
      ControllerGenerator.run("name" => "zoo")
      File.should be_exists(file)
      File.read(file).should == fixture("zoos_controller_helper_test.rb")
    end
  end
  
  it "should generate a RSpec test if using the RSpec framework" do
    file = File.join(Mack.root, "test", "helpers", "controllers", "zoos_controller_helper_spec.rb")
    File.should_not be_exists(file)
    ControllerGenerator.run("name" => "zoo")
    File.should be_exists(file)
    File.read(file).should == fixture("zoos_controller_helper_spec.rb")
  end
  
end
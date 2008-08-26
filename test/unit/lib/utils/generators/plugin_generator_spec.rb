require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent.parent.parent + 'spec_helper'

describe PluginGenerator do
  
  after(:each) do
    FileUtils.rm_rf(bandit_dir)
  end
  
  it "should be able to properly generate the plugin files" do 
    pg = PluginGenerator.new("name" => "bandit")
    File.exists?(bandit_dir).should_not == true
    File.exists?(File.join(bandit_dir, "init.rb")).should_not == true
    File.exists?(File.join(bandit_dir, "lib")).should_not == true
    File.exists?(File.join(bandit_dir, "lib", "bandit.rb")).should_not == true
    File.exists?(File.join(bandit_dir, "lib", "tasks")).should_not == true
    
    pg.generate
    File.exists?(bandit_dir).should == true
    File.exists?(File.join(bandit_dir, "init.rb")).should == true
    File.exists?(File.join(bandit_dir, "lib")).should == true
    File.exists?(File.join(bandit_dir, "lib", "bandit.rb")).should == true
    File.exists?(File.join(bandit_dir, "lib", "tasks")).should == true
    File.exists?(File.join(bandit_dir, "lib", "tasks", "bandit_tasks.rake")).should == true
    
    File.open(File.join(bandit_dir, "init.rb"), "r") do |f|
      f.read.should == "require 'bandit'\n"
    end

    File.open(File.join(bandit_dir, "lib", "bandit.rb"), "r") do |f|
      f.read.should == "# Do work here for bandit\n"
    end
  end
  
  def bandit_dir
    Mack::Paths.plugins("bandit")
  end
  
end

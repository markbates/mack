require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack do
  
  describe "root" do
    
    it "should return the path to the application's root" do
      Mack.root.should == ENV["MACK_ROOT"]
    end
    
    it "should return pwd if a root isn't set" do
      r = Mack.root
      ENV["MACK_ROOT"] = nil
      Mack.root.should == FileUtils.pwd
      ENV["MACK_ROOT"] = r
    end
    
  end
  
  describe "env" do
    
    it "should return the environment" do
      Mack.env == "test"
    end
    
    it "should return 'development' if env isn't set" do
      ENV["MACK_ENV"] = nil
      Mack.env.should == "development"
      ENV["MACK_ENV"] = "test"
    end
    
  end
  
end

describe Mack::Configuration do
  
  describe "Existence Check" do
    
    it "should have valid reference to app_config" do
      app_config.should_not be_nil
    end
    
    it "should have valid reference to mack's app_config" do
      app_config.mack.should_not be_nil
    end
    
    it "should return nil if unknown config key is requested" do
      app_config.mack.foo_bar
    end
    
    it "should return valid reference if requested config key is valid" do
      app_config.mack.cache_classes.should == true
    end
    
  end
  
end

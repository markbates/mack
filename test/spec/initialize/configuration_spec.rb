require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe Mack do
  
  describe "root" do
    
    it "should return the path to the application's root" do
      Mack.root.should == ENV["_mack_root"]
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

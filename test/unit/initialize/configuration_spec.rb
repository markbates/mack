require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack do
  
  describe "root" do
    
    it "should return the path to the application's root" do
      Mack.root.should == ENV['MACK_ROOT']
    end
    
    it "should return pwd if a root isn't set" do
      r = Mack.root
      ENV['MACK_ROOT'] = nil
      Mack.root.should == FileUtils.pwd
      ENV['MACK_ROOT'] = r
    end
    
  end
  
  describe "env" do
    
    it "should return the environment" do
      Mack.env == 'test'
    end
    
    it "should return 'development' if env isn't set" do
      ENV['MACK_ENV'] = nil
      Mack.env.should == 'development'
      ENV['MACK_ENV'] = 'test'
    end
    
  end
  
  describe 'env?' do
    
    it 'should return true if the environment is equal' do
      Mack.should be_env(:test)
    end
    
    it 'should return false if the environment is not equal' do
      Mack.should_not be_env(:development)
    end
    
  end
  
end

describe Mack::Configuration do
  
  describe "Existence Check" do
    
    it "should have valid reference to configatron" do
      configatron.should_not be_nil
    end
    
    it "should have valid reference to mack's configatron" do
      configatron.mack.should_not be_nil
    end
    
    it "should return valid reference if requested config key is valid" do
      configatron.mack.cache_classes.should == true
    end
    
  end
  
  it "should load facets before loading app config" do
    configatron.mack.test_facets.should == 86400
    configatron.test_facets.should == 900
  end
  
end

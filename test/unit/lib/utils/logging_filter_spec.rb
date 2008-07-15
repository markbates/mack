require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent.parent + 'spec_helper'

describe Mack::Logging::Filter do
  
  describe "add" do
    
    it "should add a parameter to the filter" do
      Mack::Logging::Filter.list.should_not include(:pickles)
      Mack::Logging::Filter.add(:pickles)
      Mack::Logging::Filter.list.should include(:pickles)
    end
    
    it "should add multiple parameters to the filter" do
      Mack::Logging::Filter.list.should_not include(:foo)
      Mack::Logging::Filter.list.should_not include(:bar)
      Mack::Logging::Filter.add(:foo, :bar)
      Mack::Logging::Filter.list.should include(:foo)
      Mack::Logging::Filter.list.should include(:bar)
    end
    
  end
  
  describe "list" do
    
    it "should return the list of filtered parameters" do
      Mack::Logging::Filter.list.should be_is_a(Array)
      Mack::Logging::Filter.list.should include(:password)
    end
    
  end
  
  describe "remove" do
    
    it "should remove a parameter from the filter" do
      Mack::Logging::Filter.list.should include(:pickles)
      Mack::Logging::Filter.remove(:pickles)
      Mack::Logging::Filter.list.should_not include(:pickles)
    end
    
    it "should remove multiple parameters from the filter" do
      Mack::Logging::Filter.list.should include(:foo)
      Mack::Logging::Filter.list.should include(:bar)
      Mack::Logging::Filter.remove(:foo, :bar)
      Mack::Logging::Filter.list.should_not include(:foo)
      Mack::Logging::Filter.list.should_not include(:bar)
    end
    
  end
  
end
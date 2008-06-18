require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "Rendering Engine Registry" do
  
  describe "=> register new engine" do
    
    before(:all) do
      @reg = Mack::Rendering::Engine::Registry
    end
    
    it "should return false when has_key is called with invalid key" do
      @reg.engines.should_not have_key(:foo)
    end
  
    it "should successfully register a new engine" do
      @reg.register(:foo, :erb)
      @reg.engines.should have_key(:foo)
    end
    
    it "should be return correct engine when passed a valid key" do
      @reg.engines[:foo].should == [:erb]
    end
  end
  
  describe "=> register existing engine" do
    before(:all) do
      @reg = Mack::Rendering::Engine::Registry
    end
    
    it "should append newest engine to the registered list" do
      @reg.register(:bar, :erb)
      @reg.engines.should have_key(:bar)
      @reg.register(:bar, :sass)
      @reg.engines[:bar].should == [:sass, :erb]
    end
  end
end
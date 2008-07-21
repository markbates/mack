require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")

describe Mack::RunnerHelpers::Registry do
  
  class Mack::RunnerHelpers::FauxHelper
  end
  
  DEFAULT_RUNNER_HELPERS = [Mack::RunnerHelpers::RequestLogger, Mack::RunnerHelpers::Session]
  
  before(:each) do
    Mack::RunnerHelpers::Registry.instance.instance_variable_set("@runner_helpers", DEFAULT_RUNNER_HELPERS.dup)
  end
  
  after(:each) do
    Mack::RunnerHelpers::Registry.instance.instance_variable_set("@runner_helpers", DEFAULT_RUNNER_HELPERS.dup)
  end
  
  describe "add" do
    
    it "should add a class only once" do
      Mack::RunnerHelpers::Registry.helpers.should == DEFAULT_RUNNER_HELPERS
      Mack::RunnerHelpers::Registry.add(Mack::RunnerHelpers::RequestLogger)
      Mack::RunnerHelpers::Registry.helpers.should == DEFAULT_RUNNER_HELPERS
    end
    
    it "should allow for a class to be inserted anywhere in the list" do
      Mack::RunnerHelpers::Registry.helpers.should == DEFAULT_RUNNER_HELPERS
      Mack::RunnerHelpers::Registry.add(Mack::RunnerHelpers::FauxHelper, 1)
      Mack::RunnerHelpers::Registry.helpers.should == [Mack::RunnerHelpers::RequestLogger, Mack::RunnerHelpers::FauxHelper, Mack::RunnerHelpers::Session]
    end
    
  end
  
  describe "remove" do
    
    it "should remove a helper from the list" do
      Mack::RunnerHelpers::Registry.helpers.should == DEFAULT_RUNNER_HELPERS
      Mack::RunnerHelpers::Registry.add(Mack::RunnerHelpers::FauxHelper)
      Mack::RunnerHelpers::Registry.helpers.should == [Mack::RunnerHelpers::RequestLogger, Mack::RunnerHelpers::Session, Mack::RunnerHelpers::FauxHelper]
      Mack::RunnerHelpers::Registry.remove(Mack::RunnerHelpers::FauxHelper)
      Mack::RunnerHelpers::Registry.helpers.should == DEFAULT_RUNNER_HELPERS
    end
  end
  
  describe "move_to_top" do
    
    it "should move a helper to the top of the list" do
      Mack::RunnerHelpers::Registry.helpers.should == DEFAULT_RUNNER_HELPERS
      Mack::RunnerHelpers::Registry.move_to_top(Mack::RunnerHelpers::Session)
      Mack::RunnerHelpers::Registry.helpers.should == [Mack::RunnerHelpers::Session, Mack::RunnerHelpers::RequestLogger]
    end
    
  end
  
  describe "move_to_bottom" do
    it "should move a helper to the bottom of the list" do
      Mack::RunnerHelpers::Registry.helpers.should == DEFAULT_RUNNER_HELPERS
      Mack::RunnerHelpers::Registry.move_to_bottom(Mack::RunnerHelpers::RequestLogger)
      Mack::RunnerHelpers::Registry.helpers.should == [Mack::RunnerHelpers::Session, Mack::RunnerHelpers::RequestLogger]
    end
  end
  
end
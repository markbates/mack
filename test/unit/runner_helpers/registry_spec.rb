require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")

describe Mack::RunnerHelpers::Registry do
  
  describe "add" do
    
    it "should add a class only once" do
      Mack::RunnerHelpers::Registry.instance.runner_helpers.should == [Mack::RunnerHelpers::RequestLogger, Mack::RunnerHelpers::Session]
      Mack::RunnerHelpers::Registry.add(Mack::RunnerHelpers::RequestLogger)
      Mack::RunnerHelpers::Registry.instance.runner_helpers.should == [Mack::RunnerHelpers::RequestLogger, Mack::RunnerHelpers::Session]
    end
    
  end
  
  class Mack::RunnerHelpers::FauxHelper
  end
  
  describe "remove" do
    Mack::RunnerHelpers::Registry.instance.runner_helpers.should == [Mack::RunnerHelpers::RequestLogger, Mack::RunnerHelpers::Session]
    Mack::RunnerHelpers::Registry.add(Mack::RunnerHelpers::FauxHelper)
    Mack::RunnerHelpers::Registry.instance.runner_helpers.should == [Mack::RunnerHelpers::RequestLogger, Mack::RunnerHelpers::Session, Mack::RunnerHelpers::FauxHelper]
    Mack::RunnerHelpers::Registry.remove(Mack::RunnerHelpers::FauxHelper)
    Mack::RunnerHelpers::Registry.instance.runner_helpers.should == [Mack::RunnerHelpers::RequestLogger, Mack::RunnerHelpers::Session]
  end
  
end